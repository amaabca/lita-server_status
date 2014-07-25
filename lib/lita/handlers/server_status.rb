module Lita
  module Handlers
    class ServerStatus < Handler
      MESSAGE_REGEX = /(.+) is starting deploy of '(.+)' from branch '(.+)' to (.+)/i

      route(MESSAGE_REGEX, :save_status)
      route(/server status/i, :list_statuses, command: true,
            help: { "server status" => "List out the current server statuses." }
      )

      def save_status(response)
        message = response.message.body
        user, application, branch, environment = message.match(MESSAGE_REGEX).captures

        apply_status = { id: "#{application}:#{environment}",
                         message: "#{application} #{environment}: #{branch} (#{user} @ #{Time.now.to_s})" }

        redis.set("server_status:#{apply_status[:id]}", apply_status[:message])
      end

      def list_statuses(response)
        message = []
        redis.keys("server_status*").each do |key|
          message << redis.get(key)
        end

        response.reply message.join("\n")
      end
    end

    Lita.register_handler(ServerStatus)
  end
end
