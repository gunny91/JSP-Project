package bookstore.shopping;

public class BankDTO {

	
	private String account;
	private String bank;
	private String name;
	
	
	public String getAccount() {
		return account;
	}
	public void setAccount(String account) {
		this.account = account;
	}
	public String getBank() {
		return bank;
	}
	public void setBank(String bank) {
		this.bank = bank;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	@Override
	public String toString() {
		return "BankDTO [account=" + account + ", bank=" + bank + ", name=" + name + "]";
	}
	
	
}
