LuaQ  !   @bliplr.lrplugin/BlipfotoAPI.lua           !      A@   E     \    ÁÀ   Å    Ü   AA  E   \   ÁÁ  Å   Ü   AB  E   \   ÁÂ  Å   Ü ÆBÃÜ CFÃC  Á  ÁC  ËDAÄ  ÁD  ÜCÊ  ÇÄ ä  $E  JE IEF	 I 
 IIEGIÅGIEHIÅHIEFIEÆE  ä  ÅÃäÅ       $     dF ¤    äÆ      
$   
  dG   
        ¤             
  ÅÇ $È   
ÉÅÇ $   
ÉÅÇ $H   
        ÉÅÇ $      ÉÅÇ $È    ÉÅÇ $    ÉÅÇ $H ÉÅÇ $      
ÉÅÇ $È               É  0      import 
   LrBinding 
   LrDialogs 	   LrErrors    LrFunctionContext    LrHttp    LrMD5    LrPathUtils    LrTasks    LrView    LrXml    LrDate    LrPrefs    prefsForPlugin    bind    share 	   LrLogger    BlipLR    quick    debug    info    warn    err    BlipfotoAPI    initialised     apiKey    secret    apiUrl    http://api.blipfoto.com    apiVersion        @   permissionsUrl -   http://www.blipfoto.com/getpermission/258407    timeDifference            calculatedTimeDifference    randomised    __tostring    getPermissionsUrl    getBlipfotoApiKeyAndSecret    makeRequest    makeAuthRequest 	   getToken    uploadPhoto    canPostForDate    openAuthUrl    makeAnAuthRequest        &   ?      	L   
   T   L À @  Á  Á  AA  @	 T   L À   Á@  AÁ @	 T   L À   Á@  AÁ  @	 T   L À  ÁÀ A AÁ @	 T   L À   Á Á AÁ @	 T   L À  Á  A AA @	 T   L À @ ÁÀ   AA @	 T   L À  Á  AA  @	 FÀC  D Æ@D D FÁD @ ÆE BE U  ^             ð?   5    0    7    1    6    9    3    f    8    4    a    d    c    2       @      @      @      @      @       @       @    L   (   *   *   *   *   *   *   *   *   +   +   +   +   +   +   +   +   ,   ,   ,   ,   ,   ,   ,   ,   -   -   -   -   -   -   -   -   .   .   .   .   .   .   .   .   /   /   /   /   /   /   /   /   0   0   0   0   0   0   0   0   1   1   1   1   1   1   1   1   4   5   6   7   8   9   :   ;   ;   ;   ?         chunks    K           A   X      	L   
   T   L À @  Á  Á  A @	 T   L À @ Á Á A @	 T   L À   Á Á AÁ @	 T   L À   Á A AA @	 T   L À À Á   AA @	 T   L À À ÁÀ  A @	 T   L À  Á@ Á  A @	 T   L À  Á  Á AÁ @	 FÀC  D Æ@D D FÁD @ ÆE BE U  ^             ð?   b    2    0    c    5    f    e    1    d    8    4    a    3    6        @      @      @      @      @       @      @    L   C   D   D   D   D   D   D   D   D   E   E   E   E   E   E   E   E   F   F   F   F   F   F   F   F   G   G   G   G   G   G   G   G   H   H   H   H   H   H   H   H   I   I   I   I   I   I   I   I   J   J   J   J   J   J   J   J   K   K   K   K   K   K   K   K   M   N   O   P   Q   R   S   T   T   T   X         chunks    K           j   j        F @ ^          _value        j   j   j         self                q       7   E   F@À @   \  ÀÀ   Ê     ËA Ü ÀÆ B Ú   À Ë B Ü Ú@    Ã ÀË@B Ü  @  A KÂB À\Â     Z    @ýÀÀ   KAC \  @ FC@!  ÀþAA@         string    lower    type    element    setmetatable    _name    name    _value    text    childCount       ð?   childAtIndex    pairs    attributes    value     7   s   s   s   s   s   u   u   v   v   v   v   w   w   w   x   x   x   x   x   x   x   x   x   z   z   {   {   {   {   |   |   |   |   |   }   }   }   }   ~   {                                                      node     6      type    6      element    6      count    6      (for index)    (      (for limit)    (      (for step)    (      i    '      name "   '      value "   '      (for generator) .   3      (for state) .   3      (for control) .   3      k /   1      v /   1         simpleXmlMetatable 	   traverse               D      @À     \À         	   parseXml                                   
   xmlString           name          value          	   traverse    LrXml        ±     &   A   @  À     Å  ÆÁÀ  A ¤  Ü Å  ÆÁÀ  AB  Ü 	Ô À À  U Å  ÆAÂ @ À Ü@ ¡   ø^              pairs    string    gsub    ([^ !#-$&-*,%-%.0-;@-~])         +            &    format    %s%s=%s           ¡     
   E   F@À   Å   ÆÀÀ   Ü  ]   ^           string    format    %%%02X    byte     
                                       ¡         c     	       &                              ¡      ¡   ¢   ¢   ¢   ¢   ¢   ¢   ¢   £   ¥   ¥   ¥   §   §   §   «   «   «   «   «   «   «   «      «   ¯   ±         params     %      queryString    %      (for generator)    $      (for state)    $      (for control)    $      name    "      value    "           µ   ¹           @@ D   FÀ \                math    floor    currentTime        ·   ·   ·   ·   ·   ·   ·   ¹             LrDate     ½   Ê           @@ A  À  Ê    E  @A \     Ä   É Ä  É Â  	      BlipfotoAPI    makeRequest    get    time 	   tostring 
   timestamp    timeDifference    calculatedTimeDifference        ¿   ¿   ¿   ¿   ¿   ¿   Á   Á   Á   Â   Â   Æ   Æ   Æ   Ç   Ç   Ê         result          apiTime 	      
   localTime             getLocalTime    props     Î   Ö     
       @ @@ @   @    @           calculatedTimeDifference     timeDifference     
   Ð   Ð   Ð   Ð   Ñ   Ñ   Ô   Ô   Ô   Ö             props    calculateTimeDifference     Ú   î     1       @ @  À@  @ D  FÀÀ \  @     	 A@  @A @ @  @A @ @  @A @ @  @A  D  \ @  E@  F@Á \   À@ N @  @A ÌÁ ÏÀ  À Ä ÆÀÁ   @  Ü Þ          randomised    math    randomseed    currentTime    random       ð?   digest     1   Ü   Ü   Ü   Ü   Þ   Þ   Þ   Þ   Þ   Þ   ß   ß   â   â   â   â   â   â   â   â   â   ä   ä   ä   ä   ä   ä   å   å   å   å   å   å   å   æ   æ   æ   æ   æ   æ   è   è   è   è   è   è   è   ì   î         rand1    0      rand2 "   0      rand3 (   0      nonce /   0         props    LrDate    getTimeDifference    LrMD5     ò        	       D  \ @  D  \   @Ä  Æ@À@@   À  U @   À   ^        identityToken    secret    digest        ô   ô   ô   ô   ô   õ   õ   ö   ö   ÷   ÷   ù   ù   ù   ù   ù   ù   ù   ù   þ   þ   þ   þ   þ         
   timestamp          nonce          identityToken 	         secret       
   signature             getLocalTime    getTimeDifference 	   getNonce    prefs    props    LrMD5                  @           permissionsUrl                          props                  @ D   F@À          apiKey    secret                              props       L   I     A@Á    A À  ÅA ÆÁÂ D  FÂ  À ÜÚ   B AÁB  @  À  BÀ Â@  @ÀB @B AÁB  @  À  ÂBÀÂ @  @C@C CÀ  Â@  À  ÆÂCÆÄ@ÃÀÿÆBDÃCÞ        BlipfotoAPI    getBlipfotoApiKeyAndSecret    api_key    version    apiVersion    string    format 
   %s/%s/%s/    apiUrl    %s?%s    postMultipart    get    image_upload     post    error    message    data     I         !  "  "  "  #  #  #  $  $  $  $  $  $  $  $  &  (  (  *  *  *  *  *  *  *  ,  ,  ,  ,  ,  ,  ,  ,  1  1  3  3  3  3  3  3  3  5  5  5  5  5  5  5  7  7  7  ;  ;  ;  ;  ;  ;  ;  D  D  D  F  F  F  F  J  J  J  L        method     H   	   resource     H      params     H      mimeChunks     H      apiKey    H      secret    H      queryString 
   H      url    H   	   response    H      headers    H      responseTable A   H         props    paramsToQueryString    LrHttp    xmlElementToSimpleTable     V  ^   	     D  FAÀA  A À@  ÁA@   À  Á À        assert    identityToken    nonce 
   timestamp    token 
   signature    BlipfotoAPI    makeRequest        X  X  X  X  Z  Z  Z  Z  Z  Z  [  [  [  [  [  [  [  \  \  \  ^        type        	   resource           params           mimeChunks           result          rError             prefs    makeAuthSignature     b  n      E   F@À   ÁÀ  
A  	 \À Æ@AÚ   ÀÅ AAÜ   ÁA@A Å ÁÀ Ü  FÂ  Þ     	      BlipfotoAPI    makeRequest    get    token    temp_token    message 	   tostring    throwUserError    display_name        e  e  e  e  e  e  e  g  g  g  h  h  h  i  i  i  i  i  k  k  k  k  k  k  k  n     	   authCode           result          rError          errorString          	   LrErrors     r     E   A      Æ@@ Ú@  @A  Ô  ÌÀÀ
  	AAFÁA 	A Ô  ÌÀÀ
  	BFAB 	A Ô  ÌÀÀ
  	BFÁB 	A Ô  ÌÀÀ
  	CFAC 	A Ô  ÌÀÀ
Á  	CFD 	AFD 	A ÅÀ Æ ÅA @   À ÜÀFEZ  ÀEÁ E\   FÀA EÁ AÆ\ Á ÆÆ ^          image 
   photoOnly    entry       ð?   name    entry_title    value    title    entry_description    description    entry_tags    tags    entry_date    captureDate    image_upload 	   filePath    path 	   fileName 	   filename    BlipfotoAPI    makeAuthRequest    post    message 	   tostring    throwUserError 	   entry_id    result     E   v  x  y  y  y  {  }  }  }  }  }  }  }  ~  ~  ~  ~  ~  ~  ~                                                                                                          entry     D   	   resource    D      mimeChunks    D      result 2   D      rError 2   D      errorString 8   <      	   LrErrors              E   F@À   ÁÀ  
A  	 \À Æ@AÚ    Â   Þ  @ Â  Þ          BlipfotoAPI    makeAuthRequest    get    datevalidation    entry_date    message                                              date           result          rError                  ¥           @ D  F@À @         openUrlInBrowser    permissionsUrl        £  £  £  £  £  ¥            LrHttp    props     ©  À   
   D   F À @  ä          \@        postAsyncTaskWithContext    Authenticated request        ¬  ¾      D   F À    \@ K@@ ä   \@D  FÀ    ÁÀ  \  @AÁ Á JA  IA À AÂ   FAÂ DFÁÂ \A      #   attachErrorDialogToFunctionContext    addCleanupHandler    timeToUserFormat 	   %Y-%m-%d    BlipfotoAPI    makeAuthRequest    get    datevalidation    entry_date    message 	   tostring    throwUserError        ¯  ±                     ±             ®  ®  ®  ®  ¯  ±  ¯  ³  ³  ³  ³  ³  ³  µ  µ  µ  µ  µ  µ  µ  ·  ·  ·  ¸  ¸  ¸  ¹  ¹  ¹  ¹  ¾        context           currentDate          result          rError          errorString          
   LrDialogs    LrDate    getLocalTime 	   LrErrors 
   «  «  «  ¾  ¾  ¾  ¾  ¾  «  À        propertyTable     	         LrFunctionContext 
   LrDialogs    LrDate    getLocalTime 	   LrErrors                                                                                                                                                             "   "   ?   X   Z   [   \   \   \   ]   ]   ]   ^   _   `   a   b   c   h   j   j   o                     ±   ¹   ¹   Ê   Ê   Ê   Ö   Ö   Ö   î   î   î   î   î                                          L  L  L  L  L    V  ^  ^  ^  V  b  n  n  b  r      r           ¥  ¥  ¥     ©  À  À  À  À  À  À  ©  À     
   LrBinding       
   LrDialogs       	   LrErrors 	         LrFunctionContext          LrHttp          LrMD5          LrPathUtils          LrTasks          LrView          LrXml          LrDate !         prefs &         bind '         share (         logger -         debug 3         info 3         warn 3         err 3         getKey 6      
   getSecret 7         props E         simpleXmlMetatable H      	   traverse I         xmlElementToSimpleTable O         paramsToQueryString P         getLocalTime R         calculateTimeDifference U         getTimeDifference X      	   getNonce ]         makeAuthSignature d          