import HashMap       "mo:base/HashMap";
import Text          "mo:base/Text";
import Array         "mo:base/Array";
import Iter          "mo:base/Iter";
import CertifiedData "mo:base/CertifiedData";

import CertTree      "mo:ic-certification/CertTree";

import { h; base64 } = "utils";

module {

    public type File = {
        mimeType : Text;
        bytes : Blob;
        sha256 : Blob;
    };

    /// A filestore object that can serve certified data
    public class FileStore() {
        // certs
        var certStore : CertTree.Store = CertTree.newStore();
        var ct = CertTree.Ops(certStore);

        // files
        var filesMap = HashMap.HashMap<Text, File>(10, Text.equal, Text.hash);
        var fileIndex = "Index of /";

        // init
        ct.put(["http_assets", "/"], h(Text.encodeUtf8(fileIndex)));
        ct.setCertifiedData();

        public func reset() : () {
            certStore := CertTree.newStore();
            ct := CertTree.Ops(certStore);
            filesMap := HashMap.HashMap<Text, File>(10, Text.equal, Text.hash);
            fileIndex := "Index of /";
            ct.put(["http_assets", "/"], h(Text.encodeUtf8(fileIndex)));
            ct.setCertifiedData();
        };

        public func addFile(url : Text, mimeType : Text, bytes : Blob, sha256: Blob) {
            ct.put(["http_assets", Text.encodeUtf8(url)], sha256);
            filesMap.put(url, {mimeType; bytes; sha256} : File);
            fileIndex := "Index of /\n\n" # Text.join("\n", Iter.fromArray(listFiles()));
            switch (filesMap.get("/index.html")) {
                case null {};
                case (?file) {ct.put(["http_assets", "/"], file.sha256)}
            };
            ct.setCertifiedData();
        };


        public func getFile(url : Text) : ?File {
            // serve index.html from root if exists
            switch (url, filesMap.get("/index.html")) {
                case ("/", null) {
                    let indexBytes = Text.encodeUtf8(fileIndex);
                    let indexHash = h(indexBytes);
                    let fileObj = {mimeType = "text/plain"; bytes = indexBytes; sha256 = indexHash} : File;
                    return ?fileObj;
                };
                case ("/", indexFile) {
                    return indexFile;
                };
                case (url, _ ) {
                    return filesMap.get(url);
                };
            };
        };

        // public func getFileIndex() : Text {
        //     fileIndex
        // };

        public func listFiles() : [Text] {
            Array.sort(Iter.toArray(filesMap.keys()), Text.compare);
        };


        public func getCertificate(url : Text) : Text {
            let witness = ct.reveal(["http_assets", Text.encodeUtf8(url)]);
            let encoded = ct.encodeWitness(witness);
            let cert = switch (CertifiedData.getCertificate()) {
                case (?c) c;
                case null {"certificate failure" : Blob}
            };
            return (
                "certificate=:" # base64(cert) # ":, " #
                "tree=:" # base64(encoded) # ":"
            )
        };
    };
}
