{
  description = ''Scraping tools'';

  inputs.flakeNimbleLib.owner = "riinr";
  inputs.flakeNimbleLib.ref   = "master";
  inputs.flakeNimbleLib.repo  = "nim-flakes-lib";
  inputs.flakeNimbleLib.type  = "github";
  inputs.flakeNimbleLib.inputs.nixpkgs.follows = "nixpkgs";
  
  inputs.src-scraper-master.flake = false;
  inputs.src-scraper-master.ref   = "refs/heads/master";
  inputs.src-scraper-master.owner = "lurlo";
  inputs.src-scraper-master.repo  = "scraper";
  inputs.src-scraper-master.type  = "gitlab";
  
  inputs."github.com/thisago/findxml".owner = "nim-nix-pkgs";
  inputs."github.com/thisago/findxml".ref   = "master";
  inputs."github.com/thisago/findxml".repo  = "github.com/thisago/findxml";
  inputs."github.com/thisago/findxml".dir   = "";
  inputs."github.com/thisago/findxml".type  = "github";
  inputs."github.com/thisago/findxml".inputs.nixpkgs.follows = "nixpkgs";
  inputs."github.com/thisago/findxml".inputs.flakeNimbleLib.follows = "flakeNimbleLib";
  
  outputs = { self, nixpkgs, flakeNimbleLib, ...}@deps:
  let 
    lib  = flakeNimbleLib.lib;
    args = ["self" "nixpkgs" "flakeNimbleLib" "src-scraper-master"];
    over = if builtins.pathExists ./override.nix 
           then { override = import ./override.nix; }
           else { };
  in lib.mkRefOutput (over // {
    inherit self nixpkgs ;
    src  = deps."src-scraper-master";
    deps = builtins.removeAttrs deps args;
    meta = builtins.fromJSON (builtins.readFile ./meta.json);
  } );
}