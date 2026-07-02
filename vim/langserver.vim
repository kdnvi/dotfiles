vim9script
packadd lsp
var servers: list<dict<any>> = [{
  name: 'pyright', filetype: ['python'],
  path: 'pyright-langserver', args: ['--stdio'],
  workspaceConfig: {
    python: {analysis: {autoSearchPaths: true, diagnosticMode: 'openFilesOnly', useLibraryCodeForTypes: true}}
  },
}, {
  name: 'tsserver', filetype: ['javascript', 'typescript'],
  path: 'typescript-language-server', args: ['--stdio'],
  initializationOptions: {hostInfo: 'vim'},
}]

def JdtlsConfig(): dict<any>
  # TODO: keep required jdk version up to date
  if empty($JDTLS_JDK) | return {} | endif
  const jdtls_dir = $'{$HOME}/.local/share/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository'
  const launcher_jar = glob($'{jdtls_dir}/plugins/org.eclipse.equinox.launcher_*.jar')
  if empty(launcher_jar) | return {} | endif

  const config_dir = has('mac') ? 'config_mac_arm' : 'config_linux'
  const ws_dir = $'{$HOME}/.cache/jdtls/ws/{fnamemodify(getcwd(), ':t')}'
  return {
    name: 'jdtls', filetype: ['java'],
    path: $'{$JDTLS_JDK}/bin/java',
    args: [
      '-XX:+UseG1GC', '-Xms1G', '-Xmx4G',
      '-Dlog.level=ALL', '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '--add-modules=ALL-SYSTEM',
      '--add-opens=java.base/java.util=ALL-UNNAMED',
      '--add-opens=java.base/java.lang=ALL-UNNAMED',
      '-jar', launcher_jar,
      '-configuration', $'{jdtls_dir}/{config_dir}',
      '-data', ws_dir,
    ],
    # see https://github.com/eclipse-jdtls/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    initializationOptions: {
      extendedClientCapabilities: {
        classFileContentsSupport: true,
        generateToStringPromptSupport: true,
        hashCodeEqualsPromptSupport: true,
        moveRefactoringSupport: true,
        overrideMethodsPromptSupport: true,
        executeClientCommandSupport: true,
      },
      settings: {
        java: {
          autobuild: {enabled: false},
          codeGeneration: {generateComments: true, useBlocks: true},
          completion: {enabled: true, overwrite: true},
          configuration: {
            maven: {downloadSources: true, updateSnapshots: true},
            updateBuildConfiguration: 'disabled',
          },
          contentProvider: {preferred: 'fernflower'},
          compile: {nullAnalysis: {mode: 'automatic'}},
          jdt: {ls: {javac: {enabled: false}}},
          maxConcurrentBuilds: 1,
          signatureHelp: {enabled: true},
          saveActions: {organizeImports: true},
          sources: {organizeImports: {starThreshold: 9999, staticStarThreshold: 9999}},
          symbols: {includeSourceMethodDeclarations: true},
          telemetry: {enabled: false},
        }
      }
    }
  }
enddef

# use [mvn eclipse:clean eclipse:eclipse] or [./gradlew eclipse] to regenerate
var jdtls = JdtlsConfig()
if !empty(jdtls) | servers->add(jdtls) | endif

au User LspAttached {
  nmap <buffer> gd <Cmd>LspGotoDefinition<CR>
  nmap <buffer> gi <Cmd>LspGotoImpl<CR>
  nmap <buffer> gr <Cmd>LspShowReferences<CR>
  nmap <buffer> K <Cmd>LspHover<CR>
  nmap <buffer> [d <Cmd>LspDiagPrev<CR>
  nmap <buffer> ]d <Cmd>LspDiagNext<CR>
  nmap <buffer> <C-w>d <Cmd>LspDiagCurrent<CR>
  nmap <buffer> <C-w>a <Cmd>LspCodeAction<CR>
  xmap <buffer> <C-w>a <Cmd>LspCodeAction<CR>
  imap <buffer> <C-s> <Cmd>LspShowSignature<CR>
}

au User LspDetached {
  silent! nunmap <buffer> gd
  silent! nunmap <buffer> gi
  silent! nunmap <buffer> gr
  silent! nunmap <buffer> K
  silent! nunmap <buffer> [d
  silent! nunmap <buffer> ]d
  silent! nunmap <buffer> <C-w>d
}

g:LspAddServer(servers)
g:LspOptionsSet({ignoreMissingServer: true, omniComplete: true, showInlayHints: true})
defcompile
