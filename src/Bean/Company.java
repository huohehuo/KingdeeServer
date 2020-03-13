package Bean;

public class Company {
    public int id;//公司名称
    public String CompanyName;//公司名称
    public String AppVersion;//App版本
    public String AppVersion2;//App版本
    public String AppVersion3;//App版本
    public String KingdeeVersion;//金蝶版本
    public String AppID;//程序id
    public String Img_Logo;//logo地址
    public String Phone;//电话
    public String Address;//地址
    public String Remark;//备注
    public String EndTime;//终止日期格式： 20120101
    public String CanUse;//0；允许使用，1停止使用
    public String create_time;//创建日期
    public String user_num_max;//创建日期

    public Company(String companyName, String appVersion,String appVersion2,String appVersion3, String kingdeeVersion, String appID,
                   String img_Logo, String phone, String address, String remark, String endTime, String canUse, String createTime,String usermax) {
        CompanyName = companyName;
        AppVersion = appVersion;
        AppVersion2 = appVersion2;
        AppVersion3 = appVersion3;
        KingdeeVersion = kingdeeVersion;
        AppID = appID;
        Img_Logo = img_Logo;
        Phone = phone;
        Address = address;
        Remark = remark;
        EndTime = endTime;
        CanUse = canUse;
        create_time = createTime;
        user_num_max = usermax;
    }
    public Company() {
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public String getUser_num_max() {
        return user_num_max;
    }

    public void setUser_num_max(String user_num_max) {
        this.user_num_max = user_num_max;
    }

    public String getAppVersion2() {
        return AppVersion2;
    }

    public void setAppVersion2(String appVersion2) {
        AppVersion2 = appVersion2;
    }

    public String getAppVersion3() {
        return AppVersion3;
    }

    public void setAppVersion3(String appVersion3) {
        AppVersion3 = appVersion3;
    }

    public String getCreateTime() {
        return create_time;
    }

    public void setCreateTime(String createTime) {
        create_time = createTime;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCompanyName() {
        return CompanyName;
    }

    public void setCompanyName(String companyName) {
        CompanyName = companyName;
    }

    public String getAppVersion() {
        return AppVersion;
    }

    public void setAppVersion(String appVersion) {
        AppVersion = appVersion;
    }

    public String getKingdeeVersion() {
        return KingdeeVersion;
    }

    public void setKingdeeVersion(String kingdeeVersion) {
        KingdeeVersion = kingdeeVersion;
    }

    public String getAppID() {
        return AppID;
    }

    public void setAppID(String appID) {
        AppID = appID;
    }

    public String getImg_Logo() {
        return Img_Logo;
    }

    public void setImg_Logo(String img_Logo) {
        Img_Logo = img_Logo;
    }

    public String getPhone() {
        return Phone;
    }

    public void setPhone(String phone) {
        Phone = phone;
    }

    public String getAddress() {
        return Address;
    }

    public void setAddress(String address) {
        Address = address;
    }

    public String getRemark() {
        return Remark;
    }

    public void setRemark(String remark) {
        Remark = remark;
    }

    public String getEndTime() {
        return EndTime;
    }

    public void setEndTime(String endTime) {
        EndTime = endTime;
    }

    public String getCanUse() {
        return CanUse;
    }

    public void setCanUse(String canUse) {
        CanUse = canUse;
    }
}
