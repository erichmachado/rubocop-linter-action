# frozen_string_literal: true

module Github
  class Data
    attr_reader :event

    def initialize(event)
      @event = event
    end

    def sha
      ENV["GITHUB_SHA"]
    end

    def ref
      ENV["GITHUB_REF"]
    end

    def head_ref
      ENV["GITHUB_HEAD_REF"]
    end

    def base_ref
      ENV["GITHUB_BASE_REF"]
    end

    def token
      ENV["GITHUB_TOKEN"]
    end

    def owner
      ENV["GITHUB_REPOSITORY_OWNER"] || event.dig("repository", "owner", "login")
    end

    def repo
      ENV["GITHUB_REPOSITORY_NAME"] || event.dig("repository", "name")
    end

    def workspace
      ENV["GITHUB_WORKSPACE"]
    end
  end
end
