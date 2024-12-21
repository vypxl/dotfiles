config:
let
  utils = {
    dotfile = name: ../../config/${name};
    dotfile_mut = name: config.lib.file.mkOutOfStoreSymlink "/home/thomas/dots/config/${name}";
    read_dotfile = name: builtins.readFile (utils.dotfile name);
    dotfile_dir = name: {
      source = utils.dotfile name;
      recursive = true;
    };
    dotfile_dir_mut = name: {
      source = utils.dotfile_mut name;
      recursive = true;
    };
  };
in
utils
