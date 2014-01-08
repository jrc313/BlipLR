LuaQ  !   @bliplr.lrplugin/BlipfotoAPI.lua                 A@   E     \    ÁÀ   Å    Ü   AA  E   \ FÁÁ\  ÆAB ÂBA Ü   Å  B Ü  Ü ÂÃ ÁB  AÃ B AC C  A C 
  Ã $  dC   CFÀ Ü ÃÀÜ ÃCGÃGCHÃHCICFCÆä  $Ä  d   ¤D        ä       	$Å          	   d     	   
          Å äE    ÅÅ ä    ÅÅ äÅ                 ÅÅ ä   
ÅÅ äE   ÅÅ ä       ÅÅ äÅ       ÅÅ ä ÅÅ äE         Å  1      import 	   LrErrors    LrHttp    LrMD5    LrDate    LrPathUtils    LrPrefs    prefsForPlugin 	   loadfile    child    _PLUGIN    path 	   JSON.lua 	   LrLogger    BlipLR    quick    debug    info    warn    err    require    Utils    JSON    BlipfotoAPI    initialised     apiKey    secret    apiUrl    api.blipfoto.com    apiVersion       @
   apiFormat    json    permissionsUrl 0   http://www.blipfoto.com/getpermission/v3/340389    timeDifference            calculatedTimeDifference    randomised    getPermissionsUrl    getBlipfotoApiKeyAndSecret    makeRequest    makeAuthRequest    makeUserAuthRequest 	   getToken    uploadPhoto    canPostForDate    openAuthUrl        %   '            @@ A               Utils    getFileContents    api-key        &   &   &   &   &   '               ,   .            @@ A               Utils    getFileContents    secret        -   -   -   -   -   .               @   U     &   J      À    ÀÅA  ÆÀ  AÂ  ¤  Ü ÅA  ÆÀ  A B Ü 	Ô ÌÁB  ÂAA À  I ¡  @ù@ BÀ  Á             pairs    string    gsub    ([^ !#-$&-*,%-%.0-;@-~])         +       ð?   format    %s=%s    table    concat    &        I   K     
   E   F@À   Å   ÆÀÀ   Ü  ]   ^           string    format    %%%02X    byte     
   J   J   J   J   J   J   J   J   J   K         c     	       &   B   D   D   D   D   H   H   H   H   K   H   K   L   L   L   L   L   L   L   M   O   O   O   O   O   O   O   O   O   D   O   S   S   S   S   S   S   U         params     %      queryString    %      (for generator)          (for state)          (for control)          name          value               X   o     
   J      À    @ÊA  ÉA  @  À@AÉBAÉÂAÉ  É BIÀ¡  Àú^    	      pairs    name    type    table    value 	   filePath 	   fileName 	   filename       ð?       Z   \   \   \   \   ^   ^   `   `   `   `   `   a   a   b   b   c   c   c   e   h   h   h   \   h   m   o         params           mimeChunks          (for generator)          (for state)          (for control)          name          data          chunk               s   w           @@ D   FÀ \                math    floor    currentTime        u   u   u   u   u   u   u   w             LrDate     {              @@ A  À  Ê    E  @A \     Ä   @ Ü@Ä  Á @ Ü@Ä   É Ä  ÉÂÄ  Á D FÂÜ@        BlipfotoAPI    makeRequest    get    time 	   tostring 
   timestamp    Blip API time is     Local time is     timeDifference    calculatedTimeDifference    Time difference is         }   }   }   }   }   }                                                                                 result          apiTime 	      
   localTime             getLocalTime    info    props             
       @ @@ @   @    @           calculatedTimeDifference     timeDifference     
                                           props    calculateTimeDifference        ¬     9       @ @    A@  @   À@ D  F Á \  @     	@A  A @   A @   A @   A  D \ @  E  FÁ \    A N   A ÌÀÁ ÏÀ  À Ä  Æ Â   @  Ü  AA UA Þ    
      randomised    Initialising randomseed.    math    randomseed    currentTime    random       ð?   digest    Generated nonce:      9                                                                                    ¢   ¢   ¢   ¢   ¢   ¢   £   £   £   £   £   £   £   ¤   ¤   ¤   ¤   ¤   ¤   ¦   ¦   ¦   ¦   ¦   ¦   ¦   ¨   ¨   ¨   ¨   ¨   ª   ¬         rand1    8      rand2 %   8      rand3 +   8      nonce 2   8         props    info    LrDate    getTimeDifference    LrMD5     °   Ë    2    @      D   \    L    Ã      DÆ@ÀDÀ ÁÀ  D ÁDFAÁ À  @ A\  Å ÆÁÁ @  À  Ü A   ÁA  ÕA  À  @  
       identityToken    userSecret        secret    digest    string    format %   Signature components are %s,%s,%s,%s    Generated signature:      2   ²   ²   ³   ¶   ¶   ¶   ¶   ¶   ·   ·   ¸   »   »   ¼   ¼   ½   ½   ½   ¿   À   À   Ä   Ä   Ä   Ä   Ä   Ä   Ä   Ä   Æ   Æ   Æ   Æ   Æ   Æ   Æ   Æ   Æ   Æ   Ç   Ç   Ç   Ç   Ç   É   É   É   É   É   Ë         useUserSecret     1   
   timestamp    1      nonce 
   1      identityToken    1      secret    1   
   signature    1         getLocalTime    getTimeDifference 	   getNonce    prefs    props    LrMD5    info     Ï   Ó            @           permissionsUrl        Ñ   Ñ   Ñ   Ó             props     ×   Û            @ D   F@À          apiKey    secret        Ù   Ù   Ù   Ù   Ù   Û             props     ä         Ä     @   ÅA  ÆÀ  Ü Ü@  ÅÀ  Æ ÁÜÀ ÀA ÀÁ  Á UÁA BÁÁ  D FÃ BCÀ  CÃ ÀC @D  \ B BÁ   @    ÁB   @B ÂCÀ Â  À @	D ÀD  \   ÁÂ   @B DÀ  Â À À E @D  \   ÁB   EC  FÀ\ B  EÀ  Â À D  Â ÅB  ÆÀ  Ü \B  D   À\BDKBÆÀ\ÆÀ   ÆF@ ÇF  ÆFI  ÁÂ B ÂÆÆÇ         Making request:     table 	   tostring    BlipfotoAPI    getBlipfotoApiKeyAndSecret    api_key    http    token    s    string    format    %s://%s/v%s/%s.%s    apiUrl    apiVersion 
   apiFormat    get    %s?%s    Making get request:     post    Making post request:     multi    Making multi request:     postMultipart    Got headers:    Got response:     decode     data    error    code    message    request completed successfully        æ   æ   æ   æ   æ   æ   æ   æ   æ   è   è   è   é   í   î   î   ï   ï   ï   ñ   ñ   ñ   ñ   ñ   ñ   ñ   ñ   ñ   ñ   ñ   ñ   ó   õ   õ   ö   ö   ö   ÷   ÷   ÷   ÷   ÷   ÷   ÷   ù   ù   ù   ù   ù   ú   ú   ú   ú   ú   ú   ú   ü   ü   ý   ý   ý   ÿ   ÿ   ÿ   ÿ   ÿ                                                                   	  	  	  	  	  	  	  
  
  
  
                                                        method        	   resource           params           apiKey          secret       	   protocol          url       	   response           headers           queryString %   7   	   postBody =   I      mimeChunks O   ^      responseTable m            info    props    paramsToQueryString    LrHttp    paramsToMimeChunks    JSON     #  +       À  Â     @AÀ@ A A@   À             nonce 
   timestamp    token 
   signature    BlipfotoAPI    makeRequest        $  $  %  )  )  )  )  )  )  )  *  *  *  *  *  *  *  +        type        	   resource           params           isUserRequest              makeAuthSignature     -  2      Å     A@Ü@ Å  ÆÀÀ   @  Â Ý Þ           assert    identityToken    BlipfotoAPI    makeAuthRequest        /  /  /  /  0  0  0  0  0  0  0  0  2        type        	   resource           params              prefs     6  B   !   D      À   \@E@  FÀ À  Á  
A  	\À ÆAÚ   ÀÅÀ AÜ  B@A @ÅÀ Á Ü Á FAÂ  EÁ Â \ Þ           Getting token:     BlipfotoAPI    makeAuthRequest    get    token    temp_token    message 	   tostring    throwUserError    display_name    secret     !   8  8  8  8  9  9  9  9  9  9  9  ;  ;  ;  <  <  <  =  =  =  =  =  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  B     	   authCode            result           rError           errorString             info 	   LrErrors     F  a   /   D      \@ A@    ÆÀ@ À Ê  A É ÁA É À Æ B Ú@  @Æ@B ÀÆB À ÆÀB ÀÅ  Æ@Ã @  ÜÀ FÁCZ  ÀE ÁC\  ADÀA E Ä\  ÆÁÃ ^          Sending photo    entry    date    captureDate    image 	   filePath    path 	   filename 
   photoOnly    title    description    tags    BlipfotoAPI    makeUserAuthRequest    multi    message 	   tostring    throwUserError 	   entry_id     /   H  H  H  J  L  N  N  O  O  O  O  O  O  R  R  R  S  S  T  T  U  U  X  X  X  X  X  X  Z  Z  Z  [  [  [  \  \  \  \  \  ^  ^  ^  ^  ^  ^  ^  a        entry     .   	   resource    .      params    .      result    .      rError    .      errorString "   &         info 	   LrErrors     e  o       E   F@À   ÁÀ  
A  	 \À Æ@AÚ    Â   Þ  @ Â  Þ          BlipfotoAPI    makeUserAuthRequest    get    datevalidation    date    message        g  g  g  g  g  g  g  i  i  i  j  j  j  l  l  o        date           result          rError               s  x    	      A   @   @@ D  FÀ @      '   Opening authentication URL in browser.    openUrlInBrowser    permissionsUrl     	   u  u  u  v  v  v  v  v  x            info    LrHttp    props                                                                                                                                                 '   .   0   1   2   2   2   3   3   3   4   5   6   7   8   9   :   U   o   w   w                        ¬   ¬   ¬   ¬   ¬   ¬   Ë   Ë   Ë   Ë   Ë   Ë   Ë   Ë   Ï   Ó   Ó   Ï   ×   Û   Û   ×   ä                 ä   #  +  +  #  -  2  2  -  6  B  B  B  6  F  a  a  a  F  e  o  e  s  x  x  x  x  s  x     	   LrErrors          LrHttp          LrMD5 	         LrDate          LrPathUtils          prefs          JSON          logger !         debug '         info '         warn '         err '         getKey 0      
   getSecret 1         props @         paramsToQueryString A         paramsToMimeChunks B         getLocalTime D         calculateTimeDifference H         getTimeDifference K      	   getNonce Q         makeAuthSignature Y          