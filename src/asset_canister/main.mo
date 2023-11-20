import Text          "mo:base/Text";
import Blob          "mo:base/Blob";
import CertifiedData "mo:base/CertifiedData";

import Http "mo:http/Http";

import FileStore "filestore";



actor class AssetCanister() {

    /// ------------------------------------------------------------------------
    /// File Storage API
    let fs = FileStore.FileStore();


    //
    // Serve HTTP Requests
    public query func http_request(req: Http.Request) : async Http.Response {
        
        let showError404 = func(url : Text) : Http.Response {{
            // cannot certify 404 error messages
            headers     = [("Content-Type", "text/plain")];
            status_code = 404;
            body        = Text.encodeUtf8("404 " # url);
        }};

        // filestore object will autodisplay indexList if index.html is not present
        let fileResponse = func(file : FileStore.File) : Http.Response {{
            headers     = [("Content-Type", file.mimeType),
                           ("IC-Certificate", fs.getCertificate(req.url))];
            status_code = 200;
            body        = file.bytes;
        }};

        switch (req.url, fs.getFile(req.url)) {
            case (_       , ?file)   fileResponse(file);
            case (url     , null )   showError404(url);
        }
    };



    // Wipes certified data on upgrade (for predictability)
    system func preupgrade() {
        CertifiedData.set(Blob.fromArray([]));
    };

}
