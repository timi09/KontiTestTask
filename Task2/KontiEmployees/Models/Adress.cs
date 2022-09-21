using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;
using System.Configuration;

namespace KontiEmployees.Models
{
    public class Adress
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "Обязательно")]
        public string Country { get; set; }

        [Required(ErrorMessage = "Обязательно")]
        public string City { get; set; }

        [Required(ErrorMessage = "Обязательно")]
        public string Street { get; set; }

        [Required(ErrorMessage = "Обязательно")]
        [IntegerValidator]
        public string HouseNum { get; set; }

        [Required(ErrorMessage = "Обязательно")]
        public string ApartmentNum { get; set; }
    }
}
