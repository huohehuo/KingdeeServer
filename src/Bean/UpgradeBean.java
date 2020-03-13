package Bean;

//尽量不变动字段，以新增的形式添加
public class UpgradeBean {
    public int uid;//公司名称
    public String CompanyName;//公司名称
    public String AppVersion;//app版本号
    public String AppVersion2;//app版本号
    public String AppVersion3;//app版本号
    public String AppID;//程序id
    public String UpgradeLog;//更新提示
    public String UpgradeLog2;//更新提示
    public String UpgradeLog3;//更新提示
    public String UpgradeTime;//更新日期
    public String UpgradeUrl;//更新地址
    public String UpgradeUrl2;//更新地址
    public String UpgradeUrl3;//更新地址





    public String EndTime;//终止日期格式： 20120101
    public String CanUse;//0；允许使用，1停止使用
    public String KingdeeVersion;//金蝶版本
    public String Img_Logo;//logo地址
    public String Phone;//电话号码
    public String Address;//地址
    public String Remark;//备注
    public String create_time;//创建日期


    public UpgradeBean(String companyName, String appVersion, String appVersion2, String appVersion3, String appID, String upgradeLog, String upgradeLog2, String upgradeLog3, String upgradeUrl, String upgradeUrl2, String upgradeUrl3, String upgradeTime) {
        CompanyName = companyName;
        AppVersion = appVersion;
        AppVersion2 = appVersion2;
        AppVersion3 = appVersion3;
        AppID = appID;
        UpgradeLog = upgradeLog;
        UpgradeLog2 = upgradeLog2;
        UpgradeLog3 = upgradeLog3;
        UpgradeTime = upgradeTime;
        UpgradeUrl = upgradeUrl;
        UpgradeUrl2 = upgradeUrl2;
        UpgradeUrl3 = upgradeUrl3;
    }

    public UpgradeBean(Company company) {
        CompanyName = company.CompanyName;
        AppVersion = company.AppVersion;
        KingdeeVersion = company.KingdeeVersion;
        AppID = company.AppID;
        Img_Logo = company.Img_Logo;
        Phone = company.Phone;
        Address = company.Address;
        Remark = company.Remark;
        EndTime = company.EndTime;
        CanUse = company.CanUse;
        create_time = company.create_time;
    }


    public UpgradeBean() {
    }

    public String getUpgradeUrl2() {
        return UpgradeUrl2;
    }

    public void setUpgradeUrl2(String upgradeUrl2) {
        UpgradeUrl2 = upgradeUrl2;
    }

    public String getUpgradeUrl3() {
        return UpgradeUrl3;
    }

    public void setUpgradeUrl3(String upgradeUrl3) {
        UpgradeUrl3 = upgradeUrl3;
    }

    public String getUpgradeLog2() {
        return UpgradeLog2;
    }

    public void setUpgradeLog2(String upgradeLog2) {
        UpgradeLog2 = upgradeLog2;
    }

    public String getUpgradeLog3() {
        return UpgradeLog3;
    }

    public void setUpgradeLog3(String upgradeLog3) {
        UpgradeLog3 = upgradeLog3;
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

    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
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

    public String getAppID() {
        return AppID;
    }

    public void setAppID(String appID) {
        AppID = appID;
    }

    public String getCanUse() {
        return CanUse;
    }

    public void setCanUse(String canUse) {
        CanUse = canUse;
    }

    public String getEndTime() {
        return EndTime;
    }

    public void setEndTime(String endTime) {
        EndTime = endTime;
    }

    public String getUpgradeLog() {
        return UpgradeLog;
    }

    public void setUpgradeLog(String upgradeLog) {
        UpgradeLog = upgradeLog;
    }

    public String getUpgradeTime() {
        return UpgradeTime;
    }

    public void setUpgradeTime(String upgradeTime) {
        UpgradeTime = upgradeTime;
    }

    public String getUpgradeUrl() {
        return UpgradeUrl;
    }

    public void setUpgradeUrl(String upgradeUrl) {
        UpgradeUrl = upgradeUrl;
    }

    public String getKingdeeVersion() {
        return KingdeeVersion;
    }

    public void setKingdeeVersion(String kingdeeVersion) {
        KingdeeVersion = kingdeeVersion;
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

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }
}
