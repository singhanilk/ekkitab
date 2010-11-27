package widgets

import java.util.Date;

class Affiliate {

    static constraints = {
		name(maxSize:128);
		address unique: true;
    }
	String name
	Date   creationDate;
	Date   updateDate;
	boolean inactive;
	Address address;
}
