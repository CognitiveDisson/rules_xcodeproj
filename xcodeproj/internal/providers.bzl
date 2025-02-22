"""# Providers

Defines providers and related types used throughout the rules in this
repository.

Most users will not need to use these providers to simply create Xcode projects,
but if you want to write your own custom rules that interact with these
rules, then you will use these providers to communicate between them.
"""

XcodeProjAutomaticTargetProcessingInfo = provider(
    """\
Provides needed information about a target to allow rules_xcodeproj to
automatically process it.

If you need more control over how a target or it's dependencies are processed,
return a `XcodeProjInfo` provider instance instead.
""",
    fields = {
        "bazel_build_mode_error": """\
If `build_mode = "bazel"`, then if this is non-`None`, it will be raised as an
error during analysis.
""",
        "bundle_id": """\
An attribute name (or `None`) to collect the bundle id string from.
""",
        "codesignopts": """\
An attribute name (or `None`) to collect the `codesignopts` `list` from.
""",
        "entitlements": """\
An attribute name (or `None`) to collect `File`s from for the
`entitlements`-like attribute.
""",
        "infoplists": """\
A sequence of attribute names to collect `File`s from for the `infoplists`-like
attributes.
""",
        "non_arc_srcs": """\
A sequence of attribute names to collect `File`s from for `non_arc_srcs`-like
attributes.
""",
        "pch": """\
An attribute name (or `None`) to collect `File`s from for the `pch`-like
attribute.
""",
        "provisioning_profile": """\
An attribute name (or `None`) to collect `File`s from for the
`provisioning_profile`-like attribute.
""",
        "should_generate_target": """\
Whether or an Xcode target should be generated for this target. Even if this
value is `False`, setting values for the other attributes can cause inputs to be
collected and shown in the Xcode project.
""",
        "srcs": """\
A sequence of attribute names to collect `File`s from for `srcs`-like
attributes.
""",
        "target_type": "See `XcodeProjInfo.target_type`.",
        "xcode_targets": """\
A `dict` mapping attribute names to target type strings (i.e. "resource" or
"compile"). Only Xcode targets from the specified attributes with the specified
target type are allowed to propagate.
""",
    },
)

target_type = struct(
    compile = "compile",
)

XcodeProjInfo = provider(
    "Provides information needed to generate an Xcode project.",
    fields = {
        "dependencies": """\
A `list` of target ids (see the `target` `struct`) that this target directly
depends on.
""",
        "inputs": """\
A value returned from `input_files.collect`, that contains the input files
for this target. It also includes the two extra fields that collect all of the
generated `Files` and all of the `Files` that should be added to the Xcode
project, but are not associated with any targets.
""",
        "linker_inputs": """\
A value returned from `linker_input_files.collect`.
""",
        "potential_target_merges": """\
A `depset` of structs with 'src' and 'dest' fields. The 'src' field is the id of
the target that can be merged into the target with the id of the 'dest' field.
""",
        "non_mergable_targets": """\
A `depset` of all static library files that are linked into top-level targets
besides their primary top-level targets.
""",
        "non_target_linker_inputs": """\
A value returned from `linker_input_files.collect`, for targets that aren't
generating Xcode targets.
""",
        "non_target_swift_info_modules": """\
A value returned from `swift_common.create_swift_info`, for targets that aren't
generating Xcode targets.
""",
        "outputs": """\
A value returned from `output_files.collect`, that contains information about
the output files for this target and its transitive dependencies.
""",
        "resource_bundle_informations": """\
A `depset` of `struct`s with information used to generate resource bundles,
which couldn't be collected from `AppleResourceInfo` alone.
""",
        "search_paths": """\
A value returned from `_process_search_paths`, that contains the search paths
needed by this target. These search paths should be added to the search paths of
any target that depends on this target.
""",
        "target": """\
A `struct` that contains information about the current target that is
potentially needed by the dependent targets.
""",
        "target_libraries": """\
A `depset` of library `File`s for targets that generate an Xcode target.
""",
        "target_type": """\
A string that categorizes the type of the current target. This will be one of
"compile", "resources", or `None`. Even if this target doesn't produce an Xcode
target, it can still have a non-`None` value for this field.
""",
        "xcode_targets": """\
A `depset` of partial json `dict` strings (e.g. a single '"Key": "Value"'
without the enclosing braces), which potentially will become targets in the
Xcode project.
""",
    },
)

XcodeProjOutputInfo = provider(
    "Provides information about the outputs of the `xcodeproj` rule.",
    fields = {
        "installer": "The xcodeproj installer.",
        "project_name": "The installed project name.",
        "spec": "The json spec.",
        "xcodeproj": "The xcodeproj file.",
    },
)

XcodeProjProvisioningProfileInfo = provider(
    "Provides information about a provisioning profile.",
    fields = {
        "profile_name": """\
The profile name (e.g. "iOS Team Provisioning Profile: com.example.app").
""",
        "team_id": """\
The Team ID the profile is associated with (e.g. "V82V4GQZXM").
""",
        "is_xcode_managed": "Whether the profile is managed by Xcode.",
    },
)
