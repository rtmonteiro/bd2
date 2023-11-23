delimiter //

create trigger credits_earned after update on takes
for each row
begin
    if NEW.grade <> 'F' and NEW.grade is not null
        and ( OLD.grade = 'F' or OLD.grade is null) then
        update student
        set tot_cred = tot_cred + (
                select credits
                from course
                where course.course_id = NEW.course_id
            )
        where student.id = NEW.id;
    end if;
end;

//

delimiter ;
