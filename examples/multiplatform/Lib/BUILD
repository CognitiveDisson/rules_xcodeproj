load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "Lib",
    srcs = [":gen_Lib.swift"],
    module_name = "Lib",
    tags = ["manual"],
    visibility = ["//visibility:public"],
    deps = [
        "@com_github_krzyzanowskim_cryptoswift//:CryptoSwift",
    ],
)

genrule(
    name = "gen_Lib.swift",
    outs = ["Lib.swift"],
    cmd = "echo 'public let greeting = \"Hello, world!\"' > $@",
)
