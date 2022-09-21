using KontiEmployees.Models;
using System.Collections.Generic;

namespace KontiEmployees.ViewModels
{
    public class AvaibleTypesWithEmployeesList
    {
        public List<Employee> Employees{ get; set; }
        public List<EmployeeType> AvaibleEmployeeTypes { get; set; }
    }
}
