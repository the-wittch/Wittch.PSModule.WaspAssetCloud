
# WASP AssetCloud PowerShell Module

A PowerShell module for interacting with **WASP AssetCloud** via command line.

API documentation can be found at: ([WASP AssetCloud API](https://www.waspassetcloud.com/Help/Api))

## Overview

The **Wittch.PSModule.WaspAssetCloud** module provides a friendly PowerShell interface over the AssetCloud REST API. It includes authentication helpers, standardized request handling, simple asset lookups, and extensible wrappers for future endpoints.

## Features

- Connect to and authenticate with AssetCloud API with a provided API Token
- Retrieve asset information using filtering parameters

## Requirements

- PowerShell 5.1 or PowerShell 7+
- Network access to your WASP AssetCloud instance
- API key with sufficient privileges

## Installation

### Import from a Module Directory

Copy the module folder to:

```[powershell]
$env:ProgramFiles\PowerShell\Modules
```

Then import normally

## References Used

([WASP AssetCloud C# Examples](https://dl.waspbarcode.com/kb/cloud/WaspCSAPI-20180803.zip?_gl=1*hxvan9*_gcl_au*NzA3ODcxMzc0LjE3ODU1MTIzNTE))
