cmake = import('cmake')
msgfmt = find_program ('msgfmt')

module_name = 'canvas-integration'

module_files = [
  'canvas_integration.vala',
]

module_deps = [
  plannercore_dep
]

shared_module(
    module_name,
    module_files,
    dependencies: module_deps,
    install: true,
    install_dir: join_paths(module_name),
)

custom_target(module_name + '.plugin_merge',
    input: module_name + '.plugin',
    output: module_name + '.plugin',
    command : [msgfmt,
               '--desktop',
               '--keyword=Description',
               '--keyword=Name',
               '-d' + join_paths(meson.source_root (), 'po', 'plugins'),
               '--template=@INPUT@',
               '-o@OUTPUT@',
               ],
    install : true,
    install_dir: join_paths(module_name),
)
