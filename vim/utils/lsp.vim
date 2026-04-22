vim9script

packadd lsp
var lsp_servers: list<dict<any>> = [{
  name: 'clangd',
  filetype: ['c', 'cpp'],
  path: 'clangd',
  args: [],
  rootSearch: ['.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', '.git'],
}, {
  name: 'pyright',
  filetype: 'python',
  path: 'pyright-langserver',
  args: ['--stdio'],
  workspaceConfig: {
    python: {
      analysis: {
        autoSearchPaths: true,
        diagnosticMode: 'openFilesOnly',
        useLibraryCodeForTypes: true,
      }
    }
  },
}, {
  name: 'tsserver',
  filetype: ['javascript', 'typescript'],
  path: 'typescript-language-server',
  args: ['--stdio'],
  initializationOptions: { hostInfo: 'vim' },
  rootSearch: ['tsconfig.json', 'jsconfig.json', 'package.json', '.git/'],
}]

# use [mvn eclipse:clean eclipse:eclipse] or [./gradlew eclipse] to regenerate
def JdtlsConfig(): dict<any>
  const jdtls_dir = $'{$XDG_DATA_HOME}/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository'
  const launcher_jar = glob($'{jdtls_dir}/plugins/org.eclipse.equinox.launcher_*.jar')
  if empty(launcher_jar)
    return {}
  endif
  return {
    name: 'jdtls',
    filetype: 'java',
    path: $'{$JDK25}/bin/java',
    args: [
      '-XX:+UseG1GC', '-Xms1G', '-Xmx4G',
      # '-Djdk.xml.maxGeneralEntitySizeLimit=0',
      # '-Djdk.xml.totalEntitySizeLimit=0',
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.level=ALL',
      '--add-modules=ALL-SYSTEM',
      '--add-opens=java.base/java.util=ALL-UNNAMED',
      '--add-opens=java.base/java.lang=ALL-UNNAMED',
      '-jar', launcher_jar,
      '-configuration', $'{jdtls_dir}/{has("mac") ? "config_mac_arm" : "config_linux"}',
      '-data', $'{$XDG_CACHE_HOME}/jdtls/ws/{fnamemodify(getcwd(), ":t")}',
    ],
    syncInit: true,
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
          autobuild: { enabled: false },
          codeGeneration: { generateComments: true, useBlocks: true },
          completion: { enabled: true, overwrite: true },
          configuration: {
            maven: { downloadSources: true, updateSnapshots: true },
            runtimes: [
              { name: 'JavaSE-11', path: $JDK11, default: true },
              { name: 'JavaSE-17', path: $JDK17 },
              { name: 'JavaSE-21', path: $JDK21 },
              { name: 'JavaSE-25', path: $JDK25 },
            ],
            updateBuildConfiguration: 'disabled',
          },
          contentProvider: { preferred: 'fernflower' },
          compile: { nullAnalysis: { mode: 'automatic' } },
          jdt: { ls: { javac: { enabled: false } } },
          maxConcurrentBuilds: 1,
          signatureHelp: { enabled: true },
          saveActions: { organizeImports: true },
          sources: { organizeImports: { starThreshold: 9999, staticStarThreshold: 9999 } },
          symbols: { includeSourceMethodDeclarations: true },
          telemetry: { enabled: false },
        }
      },
    },
  }
enddef
if !empty($JDK25)
  var jdtls = JdtlsConfig()
  if !empty(jdtls)
    lsp_servers->add(jdtls)
  endif
endif # requires $JDK25

call LspAddServer(lsp_servers)
call LspOptionsSet({
  ignoreMissingServer: true,
  omniComplete: true,
  showDiagOnStatusLine: true,
})

autocmd User LspAttached {
  setlocal formatexpr=lsp#lsp#FormatExpr()
  nnoremap <buffer> gd <Cmd>LspGotoDefinition<CR>
  nnoremap <buffer> gi <Cmd>LspGotoImpl<CR>
  nnoremap <buffer> gr <Cmd>LspShowReferences<CR>
  nnoremap <buffer> gR <Cmd>LspRename<CR>
  nnoremap <buffer> K <Cmd>LspHover<CR>
  nnoremap <buffer> ]d <Cmd>LspDiagNext<CR>
  nnoremap <buffer> [d <Cmd>LspDiagPrev<CR>
  nnoremap <buffer> <C-w>d <Cmd>LspDiagCurrent<CR>
  nnoremap <buffer> <C-w>a <Cmd>LspCodeAction<CR>
  nnoremap <buffer> <C-h> <Cmd>LspDocumentSymbol<CR>
  inoremap <buffer> <C-h> <Cmd>LspShowSignature<CR>
}

def LoadClassFile(uri: string, bnr: number)
  setbufvar(bnr, '&modifiable', true)
  setbufvar(bnr, '&swapfile', false)
  setbufvar(bnr, '&buftype', 'nofile')
  setbufvar(bnr, '&bufhidden', 'wipe')
  setbufvar(bnr, '&filetype', 'java')

  lsp#lsp#AddFile(bnr)
  var server = lsp#buffer#BufLspServerGet(bnr)
  if empty(server)
    echoerr 'jdtls: server not found for buffer'
    return
  endif

  server.rpc_a('java/classFileContents', {uri: uri}, (_, result: any) => {
    if typename(result) != 'string' || empty(result)
      echoerr $'jdtls: no content returned for {uri}'
      return
    endif
    const lines = split(result->substitute('\r\n', '\n', 'g'), '\n', true)
    setbufline(bnr, 1, lines)
    setbufvar(bnr, '&modifiable', false)
  })
enddef
augroup jdtls_class_file
  autocmd!
  autocmd BufReadCmd jdt://* LoadClassFile(bufname(), bufnr())
augroup END

def LspProgressInfo()
  for [_, info] in g:LspProgress->items()
    const pct = info.percentage >= 0 ? $'({info.percentage}%)' : ''
    const detail = !empty(info.message) ? $'{info.message}' : ''
    echo $'[{info.serverName}] {info.title}: {detail} {pct}'
  endfor
enddef
autocmd User LspProgressUpdate LspProgressInfo()

defcompile
