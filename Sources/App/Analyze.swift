import Fluent
import Vapor


enum Analyze {

    struct Command: MyAsyncCommand {
        let defaultLimit = 1

        struct Signature: CommandSignature {
            @Option(name: "limit", short: "l")
            var limit: Int?

            @Flag(name: "use-transaction", short: "t")
            var useTransaction: Bool
        }

        var help: String { "Run package analysis (fetching git repository and inspecting content)" }

        func run(using context: CommandContext, signature: Signature) async throws {
            let limit = signature.limit ?? defaultLimit

            let client = context.application.client
            let db = context.application.db
            let logger = Logger(label: "analyze")

            logger.info("using transaction: \(signature.useTransaction)")

            do {
                try await analyze(client: client, database: db, logger: logger, limit: limit,
                                  useTransaction: signature.useTransaction)
            } catch {
                logger.error("\(error.localizedDescription)")
            }

            logger.info("done.")
        }
    }

}


extension Analyze {

    static func analyze(client: Client, database: Database, logger: Logger, limit: Int, useTransaction: Bool) async throws {
        try await withThrowingTaskGroup(of: Int.self) { group in
            for n in (0..<limit) {
                group.addTask {
                    if useTransaction {
                        try await database.transaction { tx in
                            print("sleeping")
                            sleep(11)
                        }
                    } else {
                        print("sleeping")
                        sleep(11)
                    }
                    return n
                }
            }

            for try await res in group {
                logger.info("Task \(res) done")
            }
        }
    }

}
