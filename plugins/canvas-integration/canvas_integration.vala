public class Plugins.CanvasIntegration : Peas.ExtensionBase, Peas.Activatable {
    Plugins.Interface plugins;
    public Object object { owned get; construct; }
    
    public Gtk.ListBox listbox;
    public int index {get; set; }

    private Gtk.Revealer main_revealer;
    private Gtk.Grid main_grid;

    // Hardcoded project id, 12 digits long so shouldn't come up in any of the 
    // ids generated through Utils.generate_id using default length of 10
    private int64 canvas_project_id = 112358132134;
    private int canvas_color = 0xE22B27;

    bool databaseStatus = false;

    void databaseOpened() {
        databaseStatus = true;
    }

    // Inserts a new item into the canvas project with the inputted title, 
    // description, and due date.
    private void insert_item (string title, string description, string due_date) 
    {
        var item = new Objects.Item();
            item.project_id = canvas_project_id;
            item.due_date = due_date;
            item.content = title;
            item.note = description;
            item.id = Planner.utils.generate_id ();

            Planner.database.insert_item (item, -1);
    }

    public void activate() 
    {
        // Open the database and wait for the signal that it's opened
        Planner.database.opened.connect (databaseOpened);

        Planner.database.open_database();

        while (databaseStatus == false) {}

        // Check to see if the "Canvas Items" project already exists, if not,
        // then make it.
        if (!Planner.database.project_exists(canvas_project_id) {
            var canvas_project = new Objects.project();
            canvas_project.id = canvas_project_id;
            canvas_project.name = "Canvas Items";
            canvas_project.color = canvas_color;

            Planner.database.insert_project(canvas_project);
        }
    }

    public void deactivate() {
        hide_destroy();
    }

    public void update_state() {}

    public void hide_destroy() {
            main_revealer.reveal_child = false;
            Timeout.add (500, () => {
                main_grid.destroy ();
                return false;
            });
    }
}

[ModuleInit]
public void peas_register_types (GLib.TypeModule module) {
    var objmodule = module as Peas.ObjectModule;
    objmodule.register_extension_type (
        typeof (Peas.Activatable),
        typeof (Plugins.CanvasIntegration)
    );
}
