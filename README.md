# monoget-experiment

It is doable to have a monorepo of nuget-packages, but that will require the version to either be specified in the csproj file, using [minver](https://github.com/adamralph/minver) or via some convoluted commit-message convention to tell the build script how to bump the package version.

Personally, I like the specifying in csproj approach. It isn't all that hard, and as long as the build makes sure to suffix the version with a unique value (giving you a new prerelease version every time you push to a feature branch), it works well. Simple and straight forward, and you keep the current version easily visible in source code (you can just look at the csproj-file).

One has to take measures to make sure that packages cannot be overwritten under any circumstance. This only takes you so far though. You can still end up bumping the version in an illegal manner, or even decrease the version if counter measures are not in place - automatic and/or manual. An example of an automatic counter measure would involve looking at the current latest version and compare that to the proposed new version. A manual counter measure is pull requests.

Gitversion is not possible with this approach. But I don't see that Gitversion solves the main issue of preventing a package from being overwritten. It does prevent (presumably at least) illegal version bumps however, but how much of an argument against that is, I don't know until I've tried to make the manual counter measure for this.

A middle ground approach would be to use [minver](https://github.com/adamralph/minver). With that approach, you tag commits in order to decide what version should be built. There is some automation involved so you won't have to add tags all the time. A workflow will typically look like this:

When working on a change:

- tag the first commit with the a prerelease version, for example mypackage-1.2.3-preview.0.
  - mypackage- has to be configured as a prefix and is only necessary in monorepos
- push tag and eventually your branch.
- subsequent pushes will use that version as base and increase a counter at the end using the "height" (number of commits since last tag).
- a bit unclear as to what happens when you merge.

I still think this approach isn't as good as just keeping the version in the csproj. Doing so, ensures that you get a merge conflict if someone else has bumped the version while you've been working on your own branch, thus forcing you to take a stand on the version your changes will make. Also, the version will be clearly visible during code reviews.
