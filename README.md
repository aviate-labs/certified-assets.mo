# certified-assets.mo
Work in progress!

This is a (partial) reference implentation of a Motoko asset canister.  
There is a good chance it will be [replaced](https://github.com/dfinity/grant-rfps/issues/48) by a DFINITY motoko asset canister in the future.

We may just extend this into a motoko package that can be imported or ~~inherited~~ *motoko does not have inheritance* by other canisters.

Explore the example canister:
<https://jr6if-gyaaa-aaaag-qctcq-cai.icp0.io/>


## Usage

You'll probably have to run with the latest moc compiler version because dfx is being weird.

```bash
$ dfx start --background
$ dfx deploy -network=local
$ dfx deploy --network=ic
$ DFX_MOC_PATH="$(vessel bin)/moc" dfx deploy --network=ic
$ dfx generate asset_canister
$ dfx stop
```

```bash
# Compile
$ $(vessel bin)/moc $(vessel sources 2>/dev/null) -r src/asset_canister/main.mo
```

## Resources

[Rust Implementation](https://github.com/dfinity/sdk/tree/master/src/canisters/frontend/ic-certified-assets/src)

[@dfinity/assets](https://www.npmjs.com/package/@dfinity/assets)
