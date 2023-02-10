# Dev Container Features: Self Authoring Template

Devcontainers feature for the Trunk CLI tool:

> This repo defines a custom [dev container Feature](https://containers.dev/implementors/features/), hosted for free on GitHub Container Registry. It follows the [dev container Feature distribution specification](https://containers.dev/implementors/features-distribution/).

## Contents

### `trunk`

Running `trunk` inside the built container will print the greeting provided to it via its `greeting` option.

```jsonc
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/trunk-io/devcontainer-feature/trunk:1": {}
  }
}
```

```bash
$ trunk

usage
  trunk [flags] [subcommand]
  ...
```

## Repo and Feature Structure

Similar to the [`devcontainers/features`](https://github.com/devcontainers/features) repo, this repository has a `src` folder. Each Feature has its own sub-folder, containing at least a `devcontainer-feature.json` and an entrypoint script `install.sh`.

```
├── src
│   ├── trunk
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
|   ├── ...
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
...
```

An [implementing tool](https://containers.dev/supporting#tools) will composite [the documented dev container properties](https://containers.dev/implementors/features/#devcontainer-feature-json-properties) from the feature's `devcontainer-feature.json` file, and execute in the `install.sh` entrypoint script in the container during build time. Implementing tools are also free to process attributes under the `customizations` property as desired.

### Options

All available options for a Feature should be declared in the `devcontainer-feature.json`. The syntax for the `options` property can be found in the [devcontainer Feature json properties reference](https://containers.dev/implementors/features/#devcontainer-feature-json-properties).

Options are exported as Feature-scoped environment variables. The option name is captialized and sanitized according to [option resolution](https://containers.dev/implementors/features/#option-resolution).

```bash
#!/bin/bash

echo "Activating feature 'color'"
echo "The provided favorite color is: ${FAVORITE}"

...
```

## Distributing Features

### Versioning

Features are individually versioned by the `version` attribute in a Feature's `devcontainer-feature.json`. Features are versioned according to the semver specification. More details can be found in [the dev container Feature specification](https://containers.dev/implementors/features/#versioning).

### Publishing

> NOTE: The Distribution spec can be [found here](https://containers.dev/implementors/features-distribution/).
>
> While any registry [implementing the OCI Distribution spec](https://github.com/opencontainers/distribution-spec) can be used, this template will leverage GHCR (GitHub Container Registry) as the backing registry.

Features are meant to be easily sharable units of dev container configuration and installation code.

This repo contains a GitHub Action [workflow](.github/workflows/release.yaml) that will publish each feature to GHCR. By default, each Feature will be prefixed with the `<owner/<repo>` namespace. For example, the two Features in this repository can be referenced in a `devcontainer.json` with:

```
ghcr.io/devcontainers/feature-starter/color:1
ghcr.io/devcontainers/feature-starter/hello:1
```

The provided GitHub Action will also publish a third "metadata" package with just the namespace, eg: `ghcr.io/devcontainers/feature-starter`. This contains information useful for tools aiding in Feature discovery.

'`devcontainers/feature-starter`' is known as the feature collection namespace.

### Marking Feature Public

Note that by default, GHCR packages are marked as `private`. To stay within the free tier, Features need to be marked as `public`.

This can be done by navigating to the Feature's "package settings" page in GHCR, and setting the visibility to 'public`. The URL may look something like:

```
https://github.com/users/<owner>/packages/container/<repo>%2F<featureName>/settings
```

<img width="669" alt="image" src="https://user-images.githubusercontent.com/23246594/185244705-232cf86a-bd05-43cb-9c25-07b45b3f4b04.png">

### Adding Features to the Index

If you'd like your Features to appear in our [public index](https://containers.dev/features) so that other community members can find them, you can do the following:

- Go to [github.com/devcontainers/devcontainers.github.io](https://github.com/devcontainers/devcontainers.github.io)
  - This is the GitHub repo backing the [containers.dev](https://containers.dev/) spec site
- Open a PR to modify the [collection-index.yml](https://github.com/devcontainers/devcontainers.github.io/blob/gh-pages/_data/collection-index.yml) file

This index is from where [supporting tools](https://containers.dev/supporting) like [VS Code Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) and [GitHub Codespaces](https://github.com/features/codespaces) surface Features for their dev container creation UI.

#### Using private Features in Codespaces

For any Features hosted in GHCR that are kept private, the `GITHUB_TOKEN` access token in your environment will need to have `package:read` and `contents:read` for the associated repository.

Many implementing tools use a broadly scoped access token and will work automatically. GitHub Codespaces uses repo-scoped tokens, and therefore you'll need to add the permissions in `devcontainer.json`

An example `devcontainer.json` can be found below.

```jsonc
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/my-org/private-features/hello:1": {
      "greeting": "Hello"
    }
  },
  "customizations": {
    "codespaces": {
      "repositories": {
        "my-org/private-features": {
          "permissions": {
            "packages": "read",
            "contents": "read"
          }
        }
      }
    }
  }
}
```
