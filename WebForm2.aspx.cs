using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Windows;
using System.Web.UI;
using System.Windows.Forms;
using System.Web.UI.WebControls;


namespace WebApplication6
{
   

    public partial class WebForm2 : System.Web.UI.Page
    {
        public double _xsmall;
        public double _xlarge;
        public double _ysmall;
        public double _ylarge;
        public string _county;
        public string _action;
        public string _flightroute;
        public string _installations;
        public string _specialuse;
        public string _x;
        public string _y;
        public string _address;
        public string _4000;
        public string _SU4000;
        public string _AS4000;
        public string _MB4000;
        public string _check;

        public void Page_Load(object sender, EventArgs e)
        {

           _xsmall = Double.Parse(Request.QueryString["Xmin"]);
           _xlarge = Double.Parse(Request.QueryString["Xmax"]);
           _ysmall = Double.Parse(Request.QueryString["Ymin"]);
           _ylarge = Double.Parse(Request.QueryString["Ymax"]);
           _county = (Request.QueryString["county"].ToString());
           _action = (Request.QueryString["action"].ToString());
           _specialuse = (Request.QueryString["su"].ToString());
           _installations = (Request.QueryString["mi"].ToString());
           _flightroute = (Request.QueryString["fr"].ToString());
           _x = (Request.QueryString["x"].ToString());
           _y = (Request.QueryString["y"].ToString());
           _address = (Request.QueryString["ad"].ToString());
           _4000 = (Request.QueryString["Q4000"].ToString());
           _SU4000 = (Request.QueryString["Air4000"].ToString());
           _AS4000 = (Request.QueryString["Routes4000"].ToString());
           _MB4000 = (Request.QueryString["Base4000"].ToString());
           _check = (Request.QueryString["BoxCheck"].ToString());

          
        }
    }
}