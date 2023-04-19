import Fluent
import Vapor


enum Analyze {

    struct Command: MyAsyncCommand {
        let defaultLimit = 1

        struct Signature: CommandSignature {
            @Option(name: "limit", short: "l")
            var limit: Int?
        }

        var help: String { "Run package analysis (fetching git repository and inspecting content)" }

        func run(using context: CommandContext, signature: Signature) async throws {
            let limit = signature.limit ?? defaultLimit

            let client = context.application.client
            let db = context.application.db
            let logger = Logger(label: "analyze")


            do {
                try await analyze(client: client, database: db, logger: logger, limit: limit)
            } catch {
                logger.error("\(error.localizedDescription)")
            }

            logger.info("done.")
        }
    }

}


extension Analyze {

    static func analyze(client: Client, database: Database, logger: Logger, limit: Int) async throws {

        try await withThrowingTaskGroup(of: Int.self) { group in
            for n in (0..<limit) {
                group.addTask {
                    _ = try await client.get(URI(stringLiteral: "https://httpbin.org/delay/1"))
                    return n
                }
            }

            for try await res in group {
                logger.info("Task \(res) done")
            }
        }
    }

}
