Function Compare-Hash {
    [CmdletBinding(ConfirmImpact='Low')]
    Param(
        # Specify the file(s) containing sha256 checksums and associated file
        # names in sha256sum format.
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        [string[]] $Path,

        # Specify Algorithm for use in Get-FileHash
        [Parameter(Mandatory=$false)]
        [string] $Algorithm = 'sha256'
    )

    Begin {
        if (-not $PSBoundParameters.ContainsKey('InformationAction')) {
            # $InformationAction = $PSCmdlet.SessionState.PSVariable.GetValue('InformationPreference')
            $InformationPreference = 'Continue'
        }
        $StringSplitOptions = [System.StringSplitOptions]::RemoveEmptyEntries
    }

    Process {
        Get-Content -Path $Path | ForEach-Object {
            $hashexpected, $FileName = $_.Split("{ }",$StringSplitOptions)
            $hashfromfile = Get-FileHash -Path "$FileName" -Algorithm $Algorithm
            if ($hashexpected -eq $hashfromfile.Hash) {
                Write-Information "${FileName}: OK"
            } else {
                Write-Warning "${FileName}: FAILED"
            }
        }
    }
<#
.SYNOPSIS

    Verify file integrity by comparing hashes (sha256 by default) to those
    provided in -Path <FileName>.

    Provide similar behavior to sha256sum --check FILE

.DESCRIPTION

    Read hashes and file names from supplied file and compare to calculated
    hashes. Assume the format matches sha256sum. To process multiple files
    pipe Get-Item -Path *.sha256 | Compare-Hash.

    -InformationAction [Continue]

        Defaults to Continue. SilentlyContinue is similar to `sha256sum --quiet`

.INPUTS

    None or pipe multiple object with a .Path member--i.e., Get-Item -Path file1,
    file2, etc.

.OUTPUTS

    System.Management.Automation.PSObject for each line from -Path <FileName>.

        npp.7.7.1.Installer.x64.exe: OK

    Or

    Write-Warning to the warning stream:

        WARNING: npp.7.7.1.Installer.x64.exe: FAILED

.EXAMPLE

    PS> Compare-Hash .\npp.7.7.1.checksums.sha256

    npp.7.7.1.bin.7z: OK
    npp.7.7.1.bin.minimalist.7z: OK
    npp.7.7.1.bin.minimalist.x64.7z: OK
    npp.7.7.1.bin.x64.7z: OK
    npp.7.7.1.bin.x64.zip: OK
    npp.7.7.1.bin.zip: OK
    npp.7.7.1.Installer.exe: OK
    WARNING: npp.7.7.1.Installer.x64.exe: FAILED

.EXAMPLE

    PS>  Compare-Hash -Path .\npp.7.7.1.checksums.sha256, .\tst.sha256

    npp.7.7.1.bin.7z: OK
    npp.7.7.1.bin.minimalist.7z: OK
    npp.7.7.1.bin.minimalist.x64.7z: OK
    npp.7.7.1.bin.x64.7z: OK
    npp.7.7.1.bin.x64.zip: OK
    npp.7.7.1.bin.zip: OK
    npp.7.7.1.Installer.exe: OK
    WARNING: npp.7.7.1.Installer.x64.exe: FAILED
    get-item : Cannot find path 'C:\Users\username\Downloads\notepadpp\tst.sha256' because it does not exist.
    At line:1 char:1
    + get-item .\npp.7.7.1.checksums.sha256, .\tst.sha256 | Compare-Hash
    + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        + CategoryInfo          : ObjectNotFound: (C:\Users\username...adpp\tst.sha256:String) [Get-Item], ItemNotFoundEx
       ception
        + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.GetItemCommand

.EXAMPLE

    PS>  get-item .\npp.7.7.1.checksums.sha256, .\tst.sha256 | Compare-Hash

    npp.7.7.1.bin.7z: OK
    npp.7.7.1.bin.minimalist.7z: OK
    npp.7.7.1.bin.minimalist.x64.7z: OK
    npp.7.7.1.bin.x64.7z: OK
    npp.7.7.1.bin.x64.zip: OK
    npp.7.7.1.bin.zip: OK
    npp.7.7.1.Installer.exe: OK
    WARNING: npp.7.7.1.Installer.x64.exe: FAILED
    get-item : Cannot find path 'C:\Users\username\Downloads\notepadpp\tst.sha256' because it does not exist.
    At line:1 char:1
    + get-item .\npp.7.7.1.checksums.sha256, .\tst.sha256 | Compare-Hash
    + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        + CategoryInfo          : ObjectNotFound: (C:\Users\username...adpp\tst.sha256:String) [Get-Item], ItemNotFoundEx
       ception
        + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.GetItemCommand

.LINK

    sha256sum

.LINK

    Get-FileHash

.LINK

    Get-Item
#>
}

Function Write-Hash {
    [CmdletBinding(ConfirmImpact='Low')]
    Param(
        # Specify the file(s) to process through Get-FileHash
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        [string[]] $Path,

        # Specify Algorithm for use in Get-FileHash
        [Parameter(Mandatory=$false)]
        [string] $Algorithm = 'sha256'
    )

    Process {
        Get-Item $Path | Get-FileHash -Algorithm $Algorithm |
            ForEach-Object -Process {
                $_.Path = (Get-Item $_.Path).Name
                "$(($_.Hash).ToLower())  $($_.Path)"
            }
    }
<#
.SYNOPSIS

    Compute checksum message digest (sha256 by default).
    Write digest to standard out.

    Provide similar behavior to sha256sum --text FILE

.DESCRIPTION

    Print checksums in sha256sum digest format.

.INPUTS

    None or pipe multiple object with a .Path member--i.e., Get-Item -Path file1,
    file2, etc.

.OUTPUTS

    String array in sha256sum digest format.

.EXAMPLE

    PS> Get-item -Path npp* -Exclude *.asc, *.sha256, *.sig | Write-Hash | Out-File -FilePath .\npp.7.7.1.checksums.sha256 -Encoding ascii
    PS> Get-Content .\npp.7.7.1.checksums.sha256

    f0af67993bd5f420ef0d9268f9667d628090491899f6529a7a75f60244700ef1  npp.7.7.1.bin.7z
    efc4a3b4aad04892998fb6698765816ed789c8fbb4960967fd24b4f08cf004a4  npp.7.7.1.bin.minimalist.7z
    03f0271b0da0dfecc2c089967873a22d966238848a338ad8c6ce6b46450c7161  npp.7.7.1.bin.minimalist.x64.7z
    528ec2bf90fd409b4bf914c198b93db28cecd4fa2a8cdf6180f1b9cded7f8dfa  npp.7.7.1.bin.x64.7z
    0ec1b16b42bcfbb37d7f9d25b2ec09162f833e86be322c14f31a6cc2196d8042  npp.7.7.1.bin.x64.zip
    afbb90eca1e8100cc6a2611ab8a4251fc366161178bea364d4799acd671678cf  npp.7.7.1.bin.zip
    6787c524b0ac30a698237ffb035f932d7132343671b8fe8f0388ed380d19a51c  npp.7.7.1.Installer.exe
    0ef89d2a9c9b15cd4aab3f3772f62cbebb54c3856bc1bd9a4a5fb3180ea6140e  npp.7.7.1.Installer.x64.exe

.LINK

    sha256sum

.LINK

    Get-FileHash

.LINK

    Get-Item
#>
}
