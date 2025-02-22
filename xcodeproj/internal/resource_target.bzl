""" Functions for handling resource targets."""

load("@bazel_skylib//lib:paths.bzl", "paths")
load(":collections.bzl", "set_if_true")
load(":files.bzl", "parsed_file_path")
load(":input_files.bzl", "input_files")
load(":linker_input_files.bzl", "linker_input_files")
load(":output_files.bzl", "output_files")
load(":processed_target.bzl", "xcode_target")
load(":product.bzl", "process_product")
load(
    ":target_properties.bzl",
    "process_modulemaps",
    "process_swiftmodules",
)

def _process_resource_bundle(bundle, *, information):
    name = bundle.name
    id = bundle.id

    build_settings = {}

    set_if_true(
        build_settings,
        "PRODUCT_BUNDLE_IDENTIFIER",
        information.bundle_id,
    )

    package_bin_dir = bundle.package_bin_dir
    bundle_file_path = parsed_file_path(paths.join(
        package_bin_dir,
        "{}.bundle".format(name),
    ))

    linker_inputs = linker_input_files.collect_for_non_top_level(
        cc_info = None,
        objc = None,
        is_xcode_target = True,
    )

    product = process_product(
        target = None,
        product_name = name,
        product_type = "com.apple.product-type.bundle",
        bundle_file_path = bundle_file_path,
        linker_inputs = linker_inputs,
    )

    outputs = output_files.collect(
        target_files = [],
        bundle_info = None,
        default_info = None,
        swift_info = None,
        id = id,
        transitive_infos = [],
        should_produce_dto = False,
    )

    return xcode_target(
        id = id,
        name = name,
        label = bundle.label,
        configuration = bundle.configuration,
        package_bin_dir = package_bin_dir,
        platform = bundle.platform,
        product = product,
        is_swift = False,
        test_host = None,
        build_settings = build_settings,
        search_paths = {},
        modulemaps = process_modulemaps(swift_info = None),
        swiftmodules = process_swiftmodules(swift_info = None),
        inputs = input_files.from_resource_bundle(bundle),
        linker_inputs = linker_inputs,
        info_plist = None,
        dependencies = bundle.dependencies,
        outputs = outputs,
    )

def process_resource_bundles(bundles, *, resource_bundle_informations):
    """Turns a `list` of resource bundles into `xcode_target` `struct`s.

    Args:
        bundles: A list of resource bundle `struct`s, as returned from
            `collect_resources`.
        resource_bundle_informations: A list of `struct`s, as set in
            `process_resource_target`.

    Returns:
        A list of `xcode_target` `struct`s.
    """
    if not bundles:
        return None

    informations = {}
    for information in resource_bundle_informations:
        informations[information.id] = information

    return [
        _process_resource_bundle(
            bundle = bundle,
            information = informations[bundle.id],
        )
        for bundle in bundles
    ]
