module ProconBypassMan
  class RemoteMacroHttpClient < HttpClient
    def post(job_id: )
      super(request_body: {
        job_id: job_id,
      })
    end
  end
end
