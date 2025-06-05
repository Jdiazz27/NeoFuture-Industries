using Godot;
using System;
using System.IO.Ports;

public partial class Arduino : Node
{
	SerialPort serialPort;
	bool connectionLogged = false;
	float checkInterval = 0.2f; // revisar cada 200 ms para menos carga
	float timeSinceLastCheck = 0f;

	NodePath mutantSpawnerPath = new NodePath("/root/start/MutantSpawner");

	float cooldownSpawn = 1.5f; // segundos entre enemigos para evitar muchos
	float tiempoDesdeUltimoSpawn = 999f; // inicial muy alto para permitir el primero

	public override void _Ready()
	{
		try
		{
			serialPort = new SerialPort("COM7", 9600);
			serialPort.ReadTimeout = 100;
			serialPort.Open();
			GD.Print("✅ Puerto serial COM7 abierto");
		}
		catch (Exception e)
		{
			GD.PrintErr("❌ Error al abrir puerto serial: " + e.Message);
		}
	}

	public override void _Process(double delta)
	{
		if (serialPort == null || !serialPort.IsOpen) return;

		timeSinceLastCheck += (float)delta;
		tiempoDesdeUltimoSpawn += (float)delta;

		if (timeSinceLastCheck < checkInterval) return;
		timeSinceLastCheck = 0f;

		try
		{
			if (serialPort.BytesToRead > 0)
			{
				string serialMessage = serialPort.ReadLine().Trim();

				if (serialMessage == "ARDUINO CONECTADO")
				{
					if (!connectionLogged)
					{
						GD.Print("✅ Arduino conectado");
						connectionLogged = true;
					}

					if (tiempoDesdeUltimoSpawn >= cooldownSpawn)
					{
						if (HasNode(mutantSpawnerPath))
						{
							Node mutantSpawner = GetNode(mutantSpawnerPath);
							mutantSpawner.Call("spawn_enemy");
							GD.Print("🦠 Enemigo generado por señal del Arduino.");
							tiempoDesdeUltimoSpawn = 0f;
						}
						else
						{
							GD.PrintErr("⚠️ MutantSpawner no encontrado en la ruta.");
						}
					}
				}
			}
		}
		catch (TimeoutException)
		{
			// No hacer nada
		}
		catch (Exception e)
		{
			GD.PrintErr("Error serial: " + e.Message);
		}
	}

	public override void _ExitTree()
	{
		if (serialPort?.IsOpen ?? false)
		{
			serialPort.Close();
			GD.Print("🚪 Puerto serial cerrado");
		}
	}
}
