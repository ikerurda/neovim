{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./lsp.nix
    ./nvim-code-action-menu.nix
    ./lsp-signature.nix
  ];
}

#  vim.lsp = {↴                                   
#    enable = true;↴                              
#    formatOnSave = false;↴                       
#    nvimCodeActionMenu.enable = true;↴           
#    lspSignature.enable = true;↴                 
#    nix = true;↴                                 
#    python = isMaximal;↴                         
#    clang.enable = isMaximal;↴                   
#    sql = isMaximal;↴                            
#    ts = isMaximal;↴                             
#  };↴                                            
