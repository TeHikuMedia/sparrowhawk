def _merged_static_library_impl(ctx):
    libs = []
    seen = {}
    for dep in ctx.attr.deps:
        if CcInfo in dep:
            for linker_input in dep[CcInfo].linking_context.linker_inputs.to_list():
                for lib in linker_input.libraries:
                    archive = lib.pic_static_library or lib.static_library
                    if archive and archive.path not in seen:
                        seen[archive.path] = True
                        libs.append(archive)

    out = ctx.actions.declare_file("lib{}.a".format(ctx.label.name))
    ctx.actions.run_shell(
        inputs = libs,
        outputs = [out],
        command = "libtool -static -o {} {}".format(
            out.path,
            " ".join([f.path for f in libs]),
        ),
        mnemonic = "MergeStaticLibs",
    )
    return [DefaultInfo(files = depset([out]))]

merged_static_library = rule(
    implementation = _merged_static_library_impl,
    attrs = {
        "deps": attr.label_list(providers = [CcInfo]),
    },
)
