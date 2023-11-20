import Blob "mo:base/Blob";
import A "mo:base/Array";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Buffer "mo:base/Buffer";
import Random "mo:base/Random";
import Text "mo:base/Text";

import SHA256 "mo:sha256/SHA256";


// A lot of this was copied from 
// https://github.com/nomeata/motoko-certified-http

module {

    //
    // Hash convenience functions

    public func h(b1 : Blob) : Blob {
        let d = SHA256.Digest();
        d.write(Blob.toArray(b1));
        Blob.fromArray(d.sum());
    };

    public func h2(b1 : Blob, b2 : Blob) : Blob {
        let d = SHA256.Digest();
        d.write(Blob.toArray(b1));
        d.write(Blob.toArray(b2));
        Blob.fromArray(d.sum());
    };

    public func h3(b1 : Blob, b2 : Blob, b3 : Blob) : Blob {
        let d = SHA256.Digest();
        d.write(Blob.toArray(b1));
        d.write(Blob.toArray(b2));
        d.write(Blob.toArray(b3));
        Blob.fromArray(d.sum());
    };


    /*
    Base64 encoding.
    */

    // TODO: swap this out with a library
    public func base64(b : Blob) : Text {
        let base64_chars : [Text] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9","+","/"];
        let bytes = Blob.toArray(b);
        let pad_len = if (bytes.size() % 3 == 0) { 0 } else {3 - bytes.size() % 3 : Nat};
        // Using A.flatten() to avoid the A.append() deprecation warning
        let padded_bytes = A.flatten([bytes, A.tabulate<Nat8>(pad_len, func(_) { 0 })]);
        var out = "";
        for (j in Iter.range(1,padded_bytes.size() / 3)) {
            let i = j - 1 : Nat; // annoying inclusive upper bound in Iter.range
            let b1 = padded_bytes[3*i];
            let b2 = padded_bytes[3*i+1];
            let b3 = padded_bytes[3*i+2];
            let c1 = (b1 >> 2          ) & 63;
            let c2 = (b1 << 4 | b2 >> 4) & 63;
            let c3 = (b2 << 2 | b3 >> 6) & 63;
            let c4 = (b3               ) & 63;
            out #= base64_chars[Nat8.toNat(c1)]
                # base64_chars[Nat8.toNat(c2)]
                # (if (3*i+1 >= bytes.size()) { "=" } else { base64_chars[Nat8.toNat(c3)] })
                # (if (3*i+2 >= bytes.size()) { "=" } else { base64_chars[Nat8.toNat(c4)] });
        };
        return out
    };
}
