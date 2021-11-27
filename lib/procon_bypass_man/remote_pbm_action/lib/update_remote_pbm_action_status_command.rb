module ProconBypassMan
  class UpdateRemotePbmActionStatusCommand
    def initialize(pbm_job_uuid: )
      @pbm_job_uuid = pbm_job_uuid
    end

    # @return [void]
    # @param [Symbol] to_status
    def execute(to_status: )
      ProconBypassMan::UpdateRemotePbmActionStatusHttpClient.new(
        server_pool: ProconBypassMan.config.server_pool,
        path: path,
      ).put(to_status: "a")
    end

    private

    def path
      "/api/devices/#{ProconBypassMan.device_id}/pbm_jobs/#{@pbm_job_uuid}"
    end
  end
end
