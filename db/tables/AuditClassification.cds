namespace tc.tables;

entity AuditClassification {
    KEY GUID                : String(32);
        PRODUCT_GUID		: String(32);
        FEEDER		    	: String(10);
        HS		        	: String(30);
        QUESTION_GUID	    : String(32);
    	QUESTION	    	: String(5000);
	    ANSWER		    	: String(10);
    	CREATED_ON	    	: Timestamp;
    	Client              : String(32);
    	REJECTED            : hana.TINYINT;
};