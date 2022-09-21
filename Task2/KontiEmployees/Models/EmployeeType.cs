using System.ComponentModel.DataAnnotations;

namespace KontiEmployees.Models
{
    public class EmployeeType
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "�����������")]
        public string Title { get; set; }
    }
}
