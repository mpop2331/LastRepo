namespace tc.tables;

entity Questions {
    Key GUID		    : String(32);
        ECCN6		    : String(20);
        ECCN5		    : String(20) not null;
        QUESTION	    : String(5000);
   	    NOTE		    : String(2000);
    	SCENARIO        : String(10);
    	GRP		        : String(10);
    	SEPARATOR       : String(10);
    	EXPECTED	    : String(10);
    	UPLOADED    	: Timestamp;
    	KEYWORDS        : String(2000);
    	DESCRIPTION     : String(500);
};