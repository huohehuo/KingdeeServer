package Bean;

public class BackData {

    //http://oa.o-in.me:9001/repairs/history.json?code=
    /*
    [
    {
        "customer": "隋敏",
        "tel": "17809919911",
        "description": "耗电快",
        "treatment_program": "",
        "responsibility": "客责",
        "repair_code": 7740,
        "tabulation": "",
        "storage_time": "12/12/2018"
    }
    ]

    */
    public String customer;//客户名
    public String tel;//客户电话
    public String description;//异常描述
    public String treatment_program;//处理方案
    public String responsibility;//责任归属
    public int repair_code;//维修编号
    public String tabulation;//维修人员
    public String storage_time;//入库时间

    public String getCustomer() {
        return customer;
    }

    public void setCustomer(String customer) {
        this.customer = customer;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTreatment_program() {
        return treatment_program;
    }

    public void setTreatment_program(String treatment_program) {
        this.treatment_program = treatment_program;
    }

    public String getResponsibility() {
        return responsibility;
    }

    public void setResponsibility(String responsibility) {
        this.responsibility = responsibility;
    }

    public int getRepair_code() {
        return repair_code;
    }

    public void setRepair_code(int repair_code) {
        this.repair_code = repair_code;
    }

    public String getTabulation() {
        return tabulation;
    }

    public void setTabulation(String tabulation) {
        this.tabulation = tabulation;
    }

    public String getStorage_time() {
        return storage_time;
    }

    public void setStorage_time(String storage_time) {
        this.storage_time = storage_time;
    }


}
