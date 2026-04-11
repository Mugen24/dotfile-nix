{...}:
{
  imports = [
    ./ollama.nix
    # TODO: Not a module
    # ./audio/kokoro_docker.nix
    ./audio/fish-speech-docker.nix
  ];
}
