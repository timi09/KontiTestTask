using KontiEmployees.Models;
using System.Collections.Generic;

namespace KontiEmployees.ViewModels
{
    public class AvaibleTypesWithEmployee
    {
        public Employee Employee { get; set; }
        public List<EmployeeType> AvaibleEmployeeTypes { get; set; }
    }
}
