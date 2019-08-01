# sha256sumpwsh

PowerShell Module to print or check SHA256 (256-bit) checksums, similar to sha256sum

## Installation

``` {contenteditable="true" spellcheck="false" caption="PowerShell" .PowerShell}
git clone https://github.com/jfishe/sha256sumpwsh.git
Import-Module .\sha256sumpwsh\sha256sum\sha256sum.psd1
```

## Usage

### Write-Hash

    NAME
        Write-Hash

    SYNOPSIS
        Compute checksum message digest (sha256 by default).
        Write digest to standard out.

        Provide similar behavior to sha256sum --text FILE


    SYNTAX
        Write-Hash [-Path] <String[]> [[-Algorithm] <String>] [<CommonParameters>]


    DESCRIPTION
        Print checksums in sha256sum digest format.


    RELATED LINKS
        sha256sum
        Get-FileHash
        Get-Item

    REMARKS
        To see the examples, type: "get-help Write-Hash -examples".
        For more information, type: "get-help Write-Hash -detailed".
        For technical information, type: "get-help Write-Hash -full".
        For online help, type: "get-help Write-Hash -online"

### Compare-Hash

    NAME
        Compare-Hash

    SYNOPSIS
        Verify file integrity by comparing hashes (sha256 by default) to those
        provided in -Path <FileName>.

        Provide similar behavior to sha256sum --check FILE


    SYNTAX
        Compare-Hash [-Path] <String[]> [[-Algorithm] <String>] [<CommonParameters>]


    DESCRIPTION
        Read hashes and file names from supplied file and compare to calculated
        hashes. Assume the format matches sha256sum. To process multiple files
        pipe Get-Item -Path *.sha256 | Compare-Hash.

        -InformationAction [Continue]

            Defaults to Continue. SilentlyContinue is similar to `sha256sum --quiet`


    RELATED LINKS
        sha256sum
        Get-FileHash
        Get-Item

    REMARKS
        To see the examples, type: "get-help Compare-Hash -examples".
        For more information, type: "get-help Compare-Hash -detailed".
        For technical information, type: "get-help Compare-Hash -full".
        For online help, type: "get-help Compare-Hash -online"
