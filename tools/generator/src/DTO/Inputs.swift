struct Inputs: Equatable {
    var srcs: [FilePath]
    var nonArcSrcs: [FilePath]
    var hdrs: Set<FilePath>
    var pch: FilePath?
    var resources: Set<FilePath>
    var entitlements: FilePath?

    init(
        srcs: [FilePath] = [],
        nonArcSrcs: [FilePath] = [],
        hdrs: Set<FilePath> = [],
        pch: FilePath? = nil,
        resources: Set<FilePath> = [],
        entitlements: FilePath? = nil
    ) {
        self.srcs = srcs
        self.nonArcSrcs = nonArcSrcs
        self.hdrs = hdrs
        self.pch = pch
        self.resources = resources
        self.entitlements = entitlements
    }
}

extension Inputs {
    mutating func merge(_ other: Inputs) {
        srcs = other.srcs
        nonArcSrcs = other.nonArcSrcs
        hdrs = other.hdrs
        pch = other.pch
        resources.formUnion(other.resources)
    }

    func merging(_ other: Inputs) -> Inputs {
        var inputs = self
        inputs.merge(other)
        return inputs
    }
}

extension Inputs {
    var all: Set<FilePath> {
        return Set(srcs)
            .union(Set(nonArcSrcs))
            .union(Set(hdrs))
            .union(pchSet)
            .union(resources)
            .union(entitlementsSet)
    }

    private var pchSet: Set<FilePath> {
        guard let pch = pch else {
            return []
        }
        return [pch]
    }

    private var entitlementsSet: Set<FilePath> {
        guard let entitlements = entitlements else {
            return []
        }
        return [entitlements]
    }
}

// MARK: - Decodable

extension Inputs: Decodable {
    enum CodingKeys: String, CodingKey {
        case srcs
        case nonArcSrcs
        case hdrs
        case pch
        case resources
        case entitlements
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        srcs = try container.decodeFilePaths(.srcs)
        nonArcSrcs = try container.decodeFilePaths(.nonArcSrcs)
        hdrs = try container.decodeFilePaths(.hdrs)
        pch = try container.decodeIfPresent(FilePath.self, forKey: .pch)
        resources = try container.decodeFilePaths(.resources)
        entitlements = try container
            .decodeIfPresent(FilePath.self, forKey: .entitlements)
    }
}

private extension KeyedDecodingContainer where K == Inputs.CodingKeys {
    func decodeFilePaths(_ key: K) throws -> [FilePath] {
        return try decodeIfPresent([FilePath].self, forKey: key) ?? []
    }

    func decodeFilePaths(_ key: K) throws -> Set<FilePath> {
        return try decodeIfPresent(Set<FilePath>.self, forKey: key) ?? []
    }
}
