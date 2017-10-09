import Foundation

public struct TransitionActions {
    public typealias PreparationSignature =
        (_ transitionInformation: TransitionInformation) -> Void

    public typealias CleanupSignature =
        (_ transitionInformation: TransitionInformation) -> Void

    public typealias CompletionSignature =
        (_ transitionInformation: TransitionInformation) -> Void

    public init(prepare: PreparationSignature? = nil,
                cleanup: CleanupSignature? = nil,
                completion: CompletionSignature? = nil) {
        self.prepare = prepare
        self.cleanup = cleanup
        self.completion = completion
    }

    let prepare: PreparationSignature?
    let cleanup: CleanupSignature?
    let completion: CompletionSignature?
}
