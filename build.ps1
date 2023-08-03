param(
  [Parameter(Mandatory = $true)]
  [string]$PackageName,
  [Parameter(Mandatory = $true)]
  [string]$Branch,
  [Parameter(Mandatory = $true)]
  [int]$BuildNumber,
  [Parameter(Mandatory = $true)]
  [string]$GithubToken
)

"Building $PackageName on branch $Branch"

if ($Branch -ne 'refs/head/main') {
  $suffix = "beta-$BuildNumber"
}

"Setting location to $PackageName"

Set-Location $PackageName

"Restoring packages..."

dotnet restore

"Building sln..."
# potential problem: how to set assemly version properly? Does it matter though? GitVersion solves this.
dotnet build -c Release --no-restore

if ($null -ne $suffix)
{
  "Packing prerelease with suffix $suffix..."
  dotnet pack --no-build --no-restore -c Release -o packages --version-suffix $suffix
}
else {
  "Packing main version..."
  dotnet pack --no-build --no-restore -c Release -o packages
}


"Pushing package..."
dotnet nuget push ./packages/*.nupkg --source "https://nuget.pkg.github.com/kjohann/index.json" --api-key $GithubToken