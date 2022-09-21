using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using KontiEmployees.Data;
using KontiEmployees.Models;
using Microsoft.Data.SqlClient;
using KontiEmployees.ViewModels;
using System.Reflection.Metadata;
using Microsoft.AspNetCore.Http;
using System.Text.Json;
using System.Xml;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Data;
using System.IO;
using ClosedXML.Excel;

namespace KontiEmployees.Controllers
{
    public class EmployeesController : Controller
    {
        private readonly KontiEmployeesContext _context;

        public EmployeesController(KontiEmployeesContext context)
        {
            _context = context;
        }

        // GET: Employees
        public async Task<IActionResult> Index(string type)
        {
            List<Employee> employees;
            if (string.IsNullOrEmpty(type))
                employees = _context.GetAllEmployees();
            else
                employees = _context.GetEmployeesByType(type);

            List<EmployeeType> avaibleTypes = _context.GetAllEmployeeTypes();

            return View(new AvaibleTypesWithEmployeesList() { Employees = employees, AvaibleEmployeeTypes = avaibleTypes });
        }

        // GET: Employees/Create
        public IActionResult Create()
        {
            return View(new AvaibleTypesWithEmployee() { AvaibleEmployeeTypes = _context.GetAllEmployeeTypes()});
        }

        // POST: Employees/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Employee employee)
        {
            if (ModelState.IsValid)
            {
                _context.CreateEmployee(employee);

                return RedirectToAction(nameof(Index));
            }
            return View(employee);
        }

        // GET: Employees/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var employee = _context.GetEmployeeById(id);
            if (employee is null)
            {
                return NotFound();
            }
            return View(new AvaibleTypesWithEmployee() { Employee = employee,  AvaibleEmployeeTypes = _context.GetAllEmployeeTypes() });
        }

        // POST: Employees/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Employee employee)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    _context.UpdateEmployeeById(id, employee);
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (_context.GetEmployeeById(id) is null)
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(employee);
        }

        // GET: Employees/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id is null)
            {
                return NotFound();
            }
            
            var employee = _context.GetEmployeeById(id);
            if (employee is null)
            {
                return NotFound();
            }

            return View(employee);
        }

        // POST: Employees/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var employee = _context.GetEmployeeById(id);
            if (employee is not null)
            {
                _context.DeleteEmployeeById(employee.Id);
            }

            return RedirectToAction(nameof(Index));
        }

        public FileResult ExportToExcel()
        {
            DataTable dt = new DataTable("Grid");
            dt.Columns.AddRange(new DataColumn[5] 
            { 
                new DataColumn("ФИО"),
                new DataColumn("Телефон"),
                new DataColumn("E-mail"),
                new DataColumn("Тип сотрудника"),
                new DataColumn("Адрес")
            });

            var employees = _context.GetAllEmployees();

            foreach (var employee in employees)
            {
                dt.Rows.Add(employee.FullName, employee.PhoneNumber, employee.Email, employee.Type.Title,
                    $"{employee.Adress.Country}, {employee.Adress.City}, {employee.Adress.Street}, д. {employee.Adress.HouseNum}, кв. {employee.Adress.ApartmentNum}");
            }

            using (XLWorkbook wb = new XLWorkbook())
            {
                wb.Worksheets.Add(dt);
                using (MemoryStream stream = new MemoryStream()) //using System.IO;  
                {
                    wb.SaveAs(stream);
                    return File(stream.ToArray(), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "ExcelFile.xlsx");
                }
            }
        }
    }
}
