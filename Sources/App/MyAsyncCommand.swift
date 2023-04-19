import Vapor


// Credit: https://theswiftdev.com/running-and-testing-async-vapor-commands/

public protocol MyAsyncCommand: Command {
    func run(using context: CommandContext, signature: Signature) async throws
}

public extension MyAsyncCommand {
    func run(using context: CommandContext, signature: Signature) throws {
        let promise = context
            .application
            .eventLoopGroup
            .next()
            .makePromise(of: Void.self)

        promise.completeWithTask {
            try await run(using: context, signature: signature)
        }
        try promise.futureResult.wait()
    }
}
