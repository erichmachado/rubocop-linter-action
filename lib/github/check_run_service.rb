# frozen_string_literal: true

module Github
  class CheckRunService
    attr_reader :report, :github_data, :report_adapter, :check_name, :results

    def initialize(report: nil, github_data: nil, report_adapter: nil, check_name: nil)
      @report = report
      @github_data = github_data
      @report_adapter = report_adapter
      @check_name = check_name
    end

    def run
      id = create_check["id"]
      @results = report.build
      update_check(id)
    end

    private

    def create_check
      client.post(
        endpoint_url,
        create_check_payload
      )
    end

    def update_check(id, last_result = nil)
      annotations.each_slice(48) do |annotations_slice|
        last_result = client.patch(
          "#{endpoint_url}/#{id}",
          update_check_payload(annotations_slice)
        )
      end
      last_result
    end

    def client
      @client ||= Github::Client.new(github_data.token, user_agent: "rubocop-linter-action")
    end

    def summary
      report_adapter.summary(results)
    end

    def annotations
      report_adapter.annotations(results)
    end

    def conclusion
      report_adapter.conclusion(results)
    end

    def endpoint_url
      "/repos/#{github_data.owner}/#{github_data.repo}/check-runs"
    end

    def base_payload(status)
      {
        name: check_name,
        head_sha: github_data.sha,
        status: status,
        started_at: Time.now.iso8601
      }
    end

    def create_check_payload
      base_payload("in_progress")
    end

    def update_check_payload(annotations)
      base_payload("completed").merge!(
        conclusion: conclusion,
        output: {
          title: check_name,
          summary: summary,
          annotations: annotations
        }
      )
    end
  end
end
