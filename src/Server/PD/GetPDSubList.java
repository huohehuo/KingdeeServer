package Server.PD;

import Bean.PDSub;
import Bean.PDSubRequestBean;
import Bean.PDsubReturnBean;
import Utils.CommonJson;
import Utils.JDBCUtil;
import Utils.getDataBaseUrl;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by NB on 2017/8/18.
 */
@WebServlet("/GetPDSubList")
public class GetPDSubList extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");

        Connection conn = null;
        PreparedStatement sta = null;
        ResultSet rs = null;
        Gson gson = new Gson();
        try {
            List<PDSub> container = new ArrayList<>();
            System.out.println(request.getParameter("sqlip")+" "+request.getParameter("sqlport")+" "+request.getParameter("sqlname")+" "+request.getParameter("sqlpass")+" "+request.getParameter("sqluser"));
            conn = JDBCUtil.getConn(getDataBaseUrl.getUrl(request.getParameter("sqlip"), request.getParameter("sqlport"), request.getParameter("sqlname")), request.getParameter("sqlpass"), request.getParameter("sqluser"));
            String json = request.getParameter("json");
            System.out.println(json);
            PDSubRequestBean pBean = gson.fromJson(json,PDSubRequestBean.class);
            if(pBean!=null&&pBean.Fid.size()>0){
                for(int i = 0; i<pBean.Fid.size();i++){
                    if(pBean.isClear){
                        sta = conn.prepareStatement("Update ICInvBackup Set FCheckQty=0,FQtyAct=0,FAuxCheckQty=0,FAuxQtyAct=0,FChecker=0,FNote='',FAdjQty=0,FSecQty=0,FSecQtyAct=0,FSecCheckQty=0,FSecAdjQty=0 Where FInterID = ?");
                        sta.setString(1,pBean.Fid.get(i));
                        int j = sta.executeUpdate();
                        System.out.println("清零:"+j);
                        sta = conn.prepareStatement("Update ICInvBackup Set FMinus=FQtyAct-FQty-(FAdjQty*1),FSecMinus=FSecQtyAct-FSecQty-FSecAdjQty Where FInterID = ?");
                        sta.setString(1,pBean.Fid.get(i));
                        int s = sta.executeUpdate();
                        System.out.println("清零:"+s);
                    }
                    sta = conn.prepareStatement("Select a.* From ( Select t1.FInterID,rtrim(t12.fname) as fstockname,t1.FStockID,t1.FItemID,t11.FName as FSPName,t2.FNumber,t2.FName,t2.FModel,t1.FStockPlaceID, t3.FName AS FUnitName,convert(float,t1.FQty) as FQty,'0' as FQtyAct1,'0' as FCheckQty1,'0' as FAdjQty1,'' as FRemark, t1.FUnitID,t4.FUnitGroupID,LTRIM(RTRIM(t1.FBatchNo)) as FBatchNo,convert(float,t1.FQtyAct) as FQtyAct,convert(float,t1.FCheckQty) as FCheckQty,convert(float,t1.FAdjQty) as FAdjQty From ICInvBackup t1 inner join t_ICItem t2 on t1.FItemID=t2.FItemID left join t_MeasureUnit t3 on t2.FUnitID=t3.FItemID left join t_MeasureUnit t4 on t1.funitid=t4.FItemID left join t_MeasureUnit t5 on t2.FSecUnitID=t5.FItemID left join t_StockPlace t11 on t1.FStockPlaceID=t11.FSPID left join t_Stock t12 on t1.FStockID=t12.fitemid left join t_AuxItem t13 on t1.FAuxPropID=t13.fitemid Where 1=1 And t2.FDeleted<>1 And t1.FInterID = ?) as a where 1=1 and 1=1 order by FStockName Desc,FSPName,FName");
                    sta.setString(1,pBean.Fid.get(i));
                    rs = sta.executeQuery();
                    while(rs.next()){
                        PDSub pdSub = new PDSub();
                        pdSub.FID = rs.getString("FInterID");
                        pdSub.FStockID = rs.getString("FStockID");
                        pdSub.FItemID = rs.getString("FItemID");
                        pdSub.FSPName =rs.getString("FSPName");
                        pdSub.FNumber = rs.getString("FNumber");
                        pdSub.FName = rs.getString("FName");
                        pdSub.FModel = rs.getString("FModel");
                        pdSub.FStockPlaceID = rs.getString("FStockPlaceID");
                        pdSub.FUnitName = rs.getString("FUnitName");
                        pdSub.FQty = rs.getString("FQty");
                        pdSub.FQtyAct1 = rs.getString("FQtyAct1");
                        pdSub.FCheckQty1 = rs.getString("FCheckQty1");
                        pdSub.FAdjQty1 = rs.getString("FAdjQty1");
                        pdSub.FRemark = rs.getString("FRemark");
                        pdSub.FUnitID = rs.getString("FUnitID");
                        pdSub.FUnitGroupID = rs.getString("FUnitGroupID");
                        pdSub.FBatchNo = rs.getString("FBatchNo");
                        pdSub.FQtyAct = rs.getString("FQtyAct");
                        pdSub.FCheckQty = rs.getString("FCheckQty");
                        pdSub.FAdjQty = rs.getString("FAdjQty");
                        container.add(pdSub);
                    }

                }
                if(container.size()>0){
                    PDsubReturnBean pDsubReturnBean = new PDsubReturnBean();
                    pDsubReturnBean.items = container;
                    response.getWriter().write(CommonJson.getCommonJson(true,gson.toJson(pDsubReturnBean)));
                }else{
                    response.getWriter().write(CommonJson.getCommonJson(false,"无数据"));
                }
            }else{
                sta = conn.prepareStatement("Select a.* From ( Select t1.FInterID,rtrim(t12.fname) as fstockname,t1.FStockID,t1.FItemID,t11.FName as FSPName,t2.FNumber,t2.FName,t2.FModel,t1.FStockPlaceID, t3.FName AS FUnitName,convert(float,t1.FQty) as FQty,'0' as FQtyAct1,'0' as FCheckQty1,'0' as FAdjQty1,'' as FRemark, t1.FUnitID,t4.FUnitGroupID,LTRIM(RTRIM(t1.FBatchNo)) as FBatchNo,convert(float,t1.FQtyAct) as FQtyAct,convert(float,t1.FCheckQty) as FCheckQty,convert(float,t1.FAdjQty) as FAdjQty From ICInvBackup t1 inner join t_ICItem t2 on t1.FItemID=t2.FItemID left join t_MeasureUnit t3 on t2.FUnitID=t3.FItemID left join t_MeasureUnit t4 on t1.funitid=t4.FItemID left join t_MeasureUnit t5 on t2.FSecUnitID=t5.FItemID left join t_StockPlace t11 on t1.FStockPlaceID=t11.FSPID left join t_Stock t12 on t1.FStockID=t12.fitemid left join t_AuxItem t13 on t1.FAuxPropID=t13.fitemid Where 1=1 And t2.FDeleted<>1) as a where 1=1 and 1=1 order by FStockName Desc,FSPName,FName");
                rs = sta.executeQuery();
                while(rs.next()){
                    PDSub pdSub = new PDSub();
                    pdSub.FID = rs.getString("FInterID");
                    pdSub.FStockID = rs.getString("FStockID");
                    pdSub.FItemID = rs.getString("FItemID");
                    pdSub.FSPName =rs.getString("FSPName");
                    pdSub.FNumber = rs.getString("FNumber");
                    pdSub.FName = rs.getString("FName");
                    pdSub.FModel = rs.getString("FModel");
                    pdSub.FStockPlaceID = rs.getString("FStockPlaceID");
                    pdSub.FUnitName = rs.getString("FUnitName");
                    pdSub.FQty = rs.getString("FQty");
                    pdSub.FQtyAct1 = rs.getString("FQtyAct1");
                    pdSub.FCheckQty1 = rs.getString("FCheckQty1");
                    pdSub.FAdjQty1 = rs.getString("FAdjQty1");
                    pdSub.FRemark = rs.getString("FRemark");
                    pdSub.FUnitID = rs.getString("FUnitID");
                    pdSub.FUnitGroupID = rs.getString("FUnitGroupID");
                    pdSub.FBatchNo = rs.getString("FBatchNo");
                    pdSub.FQtyAct = rs.getString("FQtyAct");
                    pdSub.FCheckQty = rs.getString("FCheckQty");
                    pdSub.FAdjQty = rs.getString("FAdjQty");

                    if(pBean.isClear){
                        sta = conn.prepareStatement("Update ICInvBackup Set FCheckQty=0,FQtyAct=0,FAuxCheckQty=0,FAuxQtyAct=0   Where FInterID = ?");
                        sta.setString(1,rs.getString("FInterID"));
                        int j = sta.executeUpdate();
                        System.out.println("清零:"+j);
                    }
                    container.add(pdSub);
                }
                if(container.size()>0){
                    PDsubReturnBean pDsubReturnBean = new PDsubReturnBean();
                    pDsubReturnBean.items = container;
                    response.getWriter().write(CommonJson.getCommonJson(true,gson.toJson(pDsubReturnBean)));
                }else{
                    response.getWriter().write(CommonJson.getCommonJson(false,"无数据"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write(CommonJson.getCommonJson(false,"数据库错误\r\n----------------\r\n错误原因:\r\n"+e.toString()));

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().write(CommonJson.getCommonJson(false,"数据库错误\r\n----------------\r\n错误原因:\r\n"+e.toString()));

        }finally {
            JDBCUtil.close(rs,sta,conn);
        }
    }


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

}
