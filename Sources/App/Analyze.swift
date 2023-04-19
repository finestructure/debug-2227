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
                    let todo = try await createTodo(database, n)
                    _ = try await client.get(URI(stringLiteral: "https://httpbin.org/delay/1"))
                    try await updateTodo(database, todo)
                    _ = try await client.get(URI(stringLiteral: "https://httpbin.org/delay/1"))
                    try await updateTodo(database, todo)
                    return n
                }
            }

            for try await res in group {
                logger.info("Task \(res) done")
            }
        }
    }

    static func createTodo(_ database: Database, _ n: Int) async throws -> Todo {
        let todo = Todo(title: "Todo \(n)")
        try await todo.save(on: database)
        return todo
    }

    static func updateTodo(_ database: Database, _ todo: Todo) async throws {
        todo.title += " ."
        try await todo.save(on: database)
    }

}
