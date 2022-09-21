using KontiEmployees.Data;
using KontiEmployees.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;

namespace KontiEmployees.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly KontiEmployeesContext _employeesContext;

        public HomeController(ILogger<HomeController> logger, KontiEmployeesContext employeesContext)
        {
            _logger = logger;
            _employeesContext = employeesContext;
        }

        public IActionResult Index()
        {
            return RedirectToAction("Index", "Employees");
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
