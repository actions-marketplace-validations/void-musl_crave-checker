# Crave Checker
Loops through all running actions using a root bash script to detect crave=active.

```bash
name: Production Build
run-name: Build by @${{ github.actor }} (crave=${{ inputs.crave }})

on:
  workflow_dispatch:
    inputs:
      crave:
        description: 'Select crave status'
        required: true
        type: choice
        options:
          - inactive
          - active
        default: 'inactive'

permissions:
  actions: read
  contents: read

jobs:
  pre-flight-check:
    runs-on: ubuntu-latest
    steps:
      - name: Check for active crave runs
        if: inputs.crave == 'active'
        uses: void-musl/crave-checker@main
        with:
          gh_token: ${{ secrets.GITHUB_TOKEN }}
          run_id: ${{ github.run_id }}

  build:
    needs: pre-flight-check
    runs-on: ubuntu-latest
    steps:
      - name: Echo
        run: |
          echo 'Running'
```
