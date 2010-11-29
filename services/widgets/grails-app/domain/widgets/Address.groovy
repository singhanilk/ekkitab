package widgets

import java.util.Date;

class Address {
	static belongsTo = [affiliate:Affiliate]
    static constraints = {
		email(maxSize:128);
		addressLine1(maxSize:128);
		addressLine2(maxSize:128);
		phone(maxSize:25);
		mobilePhone(maxSize:25);
    }
	def String email; /* this is a unique key */
	def String addressLine1;
	def String addressLine2;
	def String city;
	def String state;
	def String country="India";
	def int	   postalCode;
	def String phone;
	def String mobilePhone;
	
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append(email).append(',').append("\n").
		   append(addressLine1).append(',').append("\n").
		   append(addressLine2).append(',').append("\n").
		   append(city).append(',').append("\n").
		   append(state).append(',').append("\n").
		   append(postalCode).append(',').append("\n").
		   append(country).append(',').append("\n").
		   append("phone:").append(phone).append(',').append("\n").
		   append("mobile:").append(mobilePhone);
		return sb.toString();
		   
	}
}
