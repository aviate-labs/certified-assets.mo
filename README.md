# certified-assets.mo
Work in progress!

This is a (partial) reference implentation of a Motoko asset canister.  
There is a good chance it will be [replaced](https://github.com/dfinity/grant-rfps/issues/48) by a DFINITY motoko asset canister in the future.

We may just extend this into a motoko package that can be imported or ~~inherited~~ *motoko does not have inheritance* by other canisters.


## Usage

```bash
$ dfx start --background
$ dfx deploy -network=local
$ dfx deploy --network=ic
$ dfx generate asset_canister
```

## Resources

[Rust Implementation](https://github.com/dfinity/sdk/tree/master/src/canisters/frontend/ic-certified-assets/src)

[@dfinity/assets](https://www.npmjs.com/package/@dfinity/assets)
